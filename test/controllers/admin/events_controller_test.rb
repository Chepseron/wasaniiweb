
require 'test_helper'

class Admin::EventsControllerTest < ActionDispatch::IntegrationTest
  test 'can move event from unpublished to published' do
    event = events(:vidcon)
    patch change_status_admin_event_path(event), params: {
      status: 'publish'
    }
    assert event.reload.published?
  end

  test 'can move event from unpublished to rejected' do
    event = events(:vidcon)
    patch change_status_admin_event_path(event), params: {
      status: 'reject'
    }
    assert event.reload.rejected?
  end

  test 'can move event from rejected to edited' do
    event = events(:comicon2016)
    patch change_status_admin_event_path(event), params: {
      status: 'edit'
    }
    assert event.reload.edited?
  end

  test 'can move event from edited to rejected' do
    event = events(:comicon2017)
    patch change_status_admin_event_path(event), params: {
      status: 'reject'
    }
    assert event.reload.rejected?
  end

  test 'can move event from edited to published' do
    event = events(:comicon2017)
    patch change_status_admin_event_path(event), params: {
      status: 'publish'
    }
    assert event.reload.published?
  end
end
