class Api::V1::ReviewsController < ApplicationController
  
  def index

  end

  def show

  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def load_book
    @book = Book.find_by(id: params[:id])
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
end