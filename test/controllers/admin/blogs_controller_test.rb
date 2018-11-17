
require 'test_helper'

class Admin::BlogsControllerTest < ActionDispatch::IntegrationTest
  test 'can move blog from unpublished to published' do
    blog = blogs(:born)
    patch change_status_admin_blog_path(blog), params: {
      status: 'publish'
    }
    assert blog.reload.published?
  end

  test 'can move blog from unpublished to rejected' do
    blog = blogs(:born)
    patch change_status_admin_blog_path(blog), params: {
      status: 'reject'
    }
    assert blog.reload.rejected?
  end

  test 'can move blog from rejected to edited' do
    blog = blogs(:first_single)
    patch change_status_admin_blog_path(blog), params: {
      status: 'edit'
    }
    assert blog.reload.edited?
  end

  test 'can move blog from edited to rejected' do
    blog = blogs(:second_single)
    patch change_status_admin_blog_path(blog), params: {
      status: 'reject'
    }
    assert blog.reload.rejected?
  end

  test 'can move blog from edited to published' do
    blog = blogs(:second_single)
    patch change_status_admin_blog_path(blog), params: {
      status: 'publish'
    }
    assert blog.reload.published?
  end
end
