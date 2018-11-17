# == Schema Information
#
# Table name: business_fans
#
#  id          :integer          not null, primary key
#  business_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class BusinessFansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_fan = business_fans(:one)
  end

  test "should get index" do
    get business_fans_url
    assert_response :success
  end

  test "should get new" do
    get new_business_fan_url
    assert_response :success
  end

  test "should create business_fan" do
    assert_difference('BusinessFan.count') do
      post business_fans_url, params: { business_fan: { business_id: @business_fan.business_id, user_id: @business_fan.user_id } }
    end

    assert_redirected_to business_fan_url(BusinessFan.last)
  end

  test "should show business_fan" do
    get business_fan_url(@business_fan)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_fan_url(@business_fan)
    assert_response :success
  end

  test "should update business_fan" do
    patch business_fan_url(@business_fan), params: { business_fan: { business_id: @business_fan.business_id, user_id: @business_fan.user_id } }
    assert_redirected_to business_fan_url(@business_fan)
  end

  test "should destroy business_fan" do
    assert_difference('BusinessFan.count', -1) do
      delete business_fan_url(@business_fan)
    end

    assert_redirected_to business_fans_url
  end
end
