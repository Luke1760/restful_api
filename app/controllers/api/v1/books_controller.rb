class Api::V1::BooksController < ApplicationController
  before_action :ensure_book_params_exist, only: [:show]

  def index
    @books = Book.all
    json_response("Index books successfully", true, {books: @books}, :ok)
  end

  def show
    json_response("Show book successfully", true, {book: @book}, :ok)
  end

  private
  def ensure_book_params_exist
    @book = Book.find_by(id: params[:id])
    unless @book.present?
      json_response("Cannot get book", false, {}, :not_found)
    end
  end
end