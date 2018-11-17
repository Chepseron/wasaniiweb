
require 'test_helper'

class Admin::BooksControllerTest < ActionDispatch::IntegrationTest
  test 'can move book from unpublished to published' do
    book = books(:first_book)
    patch change_status_admin_book_path(book), params: {
      status: 'publish'
    }
    assert book.reload.published?
  end

  test 'can move book from unpublished to rejected' do
    book = books(:first_book)
    patch change_status_admin_book_path(book), params: {
      status: 'reject'
    }
    assert book.reload.rejected?
  end

  test 'can move book from rejected to edited' do
    book = books(:second_book)
    patch change_status_admin_book_path(book), params: {
      status: 'edit'
    }
    assert book.reload.edited?
  end

  test 'can move book from edited to rejected' do
    book = books(:third_book)
    patch change_status_admin_book_path(book), params: {
      status: 'reject'
    }
    assert book.reload.rejected?
  end

  test 'can move book from edited to published' do
    book = books(:third_book)
    patch change_status_admin_book_path(book), params: {
      status: 'publish'
    }
    assert book.reload.published?
  end
end
