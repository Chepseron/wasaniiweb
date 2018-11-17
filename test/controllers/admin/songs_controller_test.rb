
require 'test_helper'

class Admin::SongsControllerTest < ActionDispatch::IntegrationTest
  test 'can move photo_art from unpublished to published' do
    photo_art = photo_arts(:first_photo_art)
    patch change_status_admin_photo_art_path(photo_art), params: {
      status: 'publish'
    }
    assert photo_art.reload.published?
  end

  test 'can move photo_art from unpublished to rejected' do
    photo_art = photo_arts(:first_photo_art)
    patch change_status_admin_photo_art_path(photo_art), params: {
      status: 'reject'
    }
    assert photo_art.reload.rejected?
  end

  test 'can move photo_art from rejected to edited' do
    photo_art = photo_arts(:second_photo_art)
    patch change_status_admin_photo_art_path(photo_art), params: {
      status: 'edit'
    }
    assert photo_art.reload.edited?
  end

  test 'can move photo_art from edited to rejected' do
    photo_art = photo_arts(:third_photo_art)
    patch change_status_admin_photo_art_path(photo_art), params: {
      status: 'reject'
    }
    assert photo_art.reload.rejected?
  end

  test 'can move photo_art from edited to published' do
    photo_art = photo_arts(:third_photo_art)
    patch change_status_admin_photo_art_path(photo_art), params: {
      status: 'publish'
    }
    assert photo_art.reload.published?
  end
end
