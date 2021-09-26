class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: [:index]
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authentication_with_token!, only: [:create, :update, :destroy]

  # reviews will be got from one book, because all reviews belongs_to one book.
  def index
    @reviews = @book.reviews
    reviews_serializer = parse_json(@reviews)
    json_response "Index reviews successfully", true, {reviews: reviews_serializer}, :ok
  end

  def show
    review_serializer = parse_json(@review)
    json_response "Show review successfully", true, {review: review_serializer}, :ok
  end

  # need to sign_in before create a review
  def create
    review = Review.new(review_params)
    review_serializer = parse_json(review)
    review.user_id = current_user.id
    review.book_id = params[:book_id]
    if review.save
      json_response "Created review successfully", true, {review: reviews_serializer}, :ok
    else
      json_response "Created review fail", false, {}, :unprocessable_entity
    end
  end

  def update
    review_serializer = parse_json(@review)
    if check_user_correct(@review.user)
      if @review.update(review_params)
        json_response "Updated review successfully", true, {review: review_serializer}, :ok
      else
        json_response "Updated review fail", false, {}, :unprocessable_entity
      end
    else
      json_response "You don't have permission to do this", false, {}, :unauthorized
    end
  end

  def destroy
    if check_user_correct(@review.user)
      if @review.destroy
        json_response "Deleted review successfully", true, {}, :ok
      else
        json_response "Deleted review fail", false, {}, :unprocessable_entity
      end
    else
      json_response "You don't have permission to do this", false, {}, :unauthorized
    end
  end

  private

  def load_book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response "Cannot find a book", false, {}, :not_found
    end
  end

  def load_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response "Cannot find a review", false, {}, :not_found
    end
  end

  def review_params
    params.require(:review).permit(:title, :content_rating, :recommend_rating)
  end
end