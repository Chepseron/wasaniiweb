# == Schema Information
#
# Table name: business_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class BusinessCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_category = business_categories(:one)
  end

  test "should get index" do
    get business_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_business_category_url
    assert_response :success
  end

  test "should create business_category" do
    assert_difference('BusinessCategory.count') do
      post business_categories_url, params: { business_category: {  } }
    end

    assert_redirected_to business_category_url(BusinessCategory.last)
  end

  test "should show business_category" do
    get business_category_url(@business_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_category_url(@business_category)
    assert_response :success
  end

  test "should update business_category" do
    patch business_category_url(@business_category), params: { business_category: {  } }
    assert_redirected_to business_category_url(@business_category)
  end

  test "should destroy business_category" do
    assert_difference('BusinessCategory.count', -1) do
      delete business_category_url(@business_category)
    end

    assert_redirected_to business_categories_url
  end
end
