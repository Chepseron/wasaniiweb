# == Schema Information
#
# Table name: suggested_updates
#
#  id          :integer          not null, primary key
#  content     :text
#  parent_id   :integer
#  parent_type :string
#  closed      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SuggestedUpdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suggested_update = suggested_updates(:one)
  end

  test "should get index" do
    get suggested_updates_url
    assert_response :success
  end

  test "should get new" do
    get new_suggested_update_url
    assert_response :success
  end

  test "should create suggested_update" do
    assert_difference('SuggestedUpdate.count') do
      post suggested_updates_url, params: { suggested_update: { content: @suggested_update.content, parent_id: @suggested_update.parent_id, parent_type: @suggested_update.parent_type } }
    end

    assert_redirected_to suggested_update_url(SuggestedUpdate.last)
  end

  test "should show suggested_update" do
    get suggested_update_url(@suggested_update)
    assert_response :success
  end

  test "should get edit" do
    get edit_suggested_update_url(@suggested_update)
    assert_response :success
  end

  test "should update suggested_update" do
    patch suggested_update_url(@suggested_update), params: { suggested_update: { content: @suggested_update.content, parent_id: @suggested_update.parent_id, parent_type: @suggested_update.parent_type } }
    assert_redirected_to suggested_update_url(@suggested_update)
  end

  test "should destroy suggested_update" do
    assert_difference('SuggestedUpdate.count', -1) do
      delete suggested_update_url(@suggested_update)
    end

    assert_redirected_to suggested_updates_url
  end
end
