# == Schema Information
#
# Table name: award_categories
#
#  id             :integer          not null, primary key
#  name           :string
#  award_id       :integer
#  accepts_entity :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#

require 'test_helper'

class AwardCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @award_category = award_categories(:one)
  end

  test "should get index" do
    get award_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_award_category_url
    assert_response :success
  end

  test "should create award_category" do
    assert_difference('AwardCategory.count') do
      post award_categories_url, params: { award_category: { award_id: @award_category.award_id, name: @award_category.name } }
    end

    assert_redirected_to award_category_url(AwardCategory.last)
  end

  test "should show award_category" do
    get award_category_url(@award_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_award_category_url(@award_category)
    assert_response :success
  end

  test "should update award_category" do
    patch award_category_url(@award_category), params: { award_category: { award_id: @award_category.award_id, name: @award_category.name } }
    assert_redirected_to award_category_url(@award_category)
  end

  test "should destroy award_category" do
    assert_difference('AwardCategory.count', -1) do
      delete award_category_url(@award_category)
    end

    assert_redirected_to award_categories_url
  end
end
