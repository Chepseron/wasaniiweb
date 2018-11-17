
require 'test_helper'

class Admin::PhotoArtControllerTest < ActionDispatch::IntegrationTest
  test 'can move song from unpublished to published' do
    song = songs(:first_song)
    patch change_status_admin_song_path(song), params: {
      status: 'publish'
    }
    assert song.reload.published?
  end

  test 'can move song from unpublished to rejected' do
    song = songs(:first_song)
    patch change_status_admin_song_path(song), params: {
      status: 'reject'
    }
    assert song.reload.rejected?
  end

  test 'can move song from rejected to edited' do
    song = songs(:second_song)
    patch change_status_admin_song_path(song), params: {
      status: 'edit'
    }
    assert song.reload.edited?
  end

  test 'can move song from edited to rejected' do
    song = songs(:third_song)
    patch change_status_admin_song_path(song), params: {
      status: 'reject'
    }
    assert song.reload.rejected?
  end

  test 'can move song from edited to published' do
    song = songs(:third_song)
    patch change_status_admin_song_path(song), params: {
      status: 'publish'
    }
    assert song.reload.published?
  end
end
