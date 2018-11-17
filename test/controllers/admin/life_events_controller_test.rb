
require 'test_helper'

class Admin::LifeEventsControllerTest < ActionDispatch::IntegrationTest
  test 'can move life_event from unpublished to published' do
    life_event = life_events(:born)
    patch change_status_admin_life_event_path(life_event), params: {
      status: 'publish'
    }
    assert life_event.reload.published?
  end

  test 'can move life_event from unpublished to rejected' do
    life_event = life_events(:born)
    patch change_status_admin_life_event_path(life_event), params: {
      status: 'reject'
    }
    assert life_event.reload.rejected?
  end

  test 'can move life_event from rejected to edited' do
    life_event = life_events(:first_single)
    patch change_status_admin_life_event_path(life_event), params: {
      status: 'edit'
    }
    assert life_event.reload.edited?
  end

  test 'can move life_event from edited to rejected' do
    life_event = life_events(:second_single)
    patch change_status_admin_life_event_path(life_event), params: {
      status: 'reject'
    }
    assert life_event.reload.rejected?
  end

  test 'can move life_event from edited to published' do
    life_event = life_events(:second_single)
    patch change_status_admin_life_event_path(life_event), params: {
      status: 'publish'
    }
    assert life_event.reload.published?
  end
end
