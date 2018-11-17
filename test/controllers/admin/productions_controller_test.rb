
require 'test_helper'

class Admin::ProductionsControllerTest < ActionDispatch::IntegrationTest
  test 'can move production from unpublished to published' do
    production = productions(:first_production)
    patch change_status_admin_production_path(production), params: {
      status: 'publish'
    }
    assert production.reload.published?
  end

  test 'can move production from unpublished to rejected' do
    production = productions(:first_production)
    patch change_status_admin_production_path(production), params: {
      status: 'reject'
    }
    assert production.reload.rejected?
  end

  test 'can move production from rejected to edited' do
    production = productions(:second_production)
    patch change_status_admin_production_path(production), params: {
      status: 'edit'
    }
    assert production.reload.edited?
  end

  test 'can move production from edited to rejected' do
    production = productions(:third_production)
    patch change_status_admin_production_path(production), params: {
      status: 'reject'
    }
    assert production.reload.rejected?
  end

  test 'can move production from edited to published' do
    production = productions(:third_production)
    patch change_status_admin_production_path(production), params: {
      status: 'publish'
    }
    assert production.reload.published?
  end
end
