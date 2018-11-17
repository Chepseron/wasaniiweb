# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  name        :string
#  business_id :integer
#  details     :text
#  image_uid   :string
#  country     :string
#  start_year  :integer
#  industry_id :integer
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#
# Indexes
#
#  index_awards_on_slug  (slug) UNIQUE
#

require 'test_helper'

class AwardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @award = awards(:one)
  end

  test "should get index" do
    get awards_url
    assert_response :success
  end

  test "should get new" do
    get new_award_url
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post awards_url, params: { award: { business_id: @award.business_id, country: @award.country, details: @award.details, image_uid: @award.image_uid, industry_id: @award.industry_id, name: @award.name, start_year: @award.start_year } }
    end

    assert_redirected_to award_url(Award.last)
  end

  test "should show award" do
    get award_url(@award)
    assert_response :success
  end

  test "should get edit" do
    get edit_award_url(@award)
    assert_response :success
  end

  test "should update award" do
    patch award_url(@award), params: { award: { business_id: @award.business_id, country: @award.country, details: @award.details, image_uid: @award.image_uid, industry_id: @award.industry_id, name: @award.name, start_year: @award.start_year } }
    assert_redirected_to award_url(@award)
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete award_url(@award)
    end

    assert_redirected_to awards_url
  end
end
