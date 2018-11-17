# == Schema Information
#
# Table name: artist_fans
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ArtistFansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist_fan = artist_fans(:one)
  end

  test "should get index" do
    get artist_fans_url
    assert_response :success
  end

  test "should get new" do
    get new_artist_fan_url
    assert_response :success
  end

  test "should create artist_fan" do
    assert_difference('ArtistFan.count') do
      post artist_fans_url, params: { artist_fan: { artist_id: @artist_fan.artist_id, user_id: @artist_fan.user_id } }
    end

    assert_redirected_to artist_fan_url(ArtistFan.last)
  end

  test "should show artist_fan" do
    get artist_fan_url(@artist_fan)
    assert_response :success
  end

  test "should get edit" do
    get edit_artist_fan_url(@artist_fan)
    assert_response :success
  end

  test "should update artist_fan" do
    patch artist_fan_url(@artist_fan), params: { artist_fan: { artist_id: @artist_fan.artist_id, user_id: @artist_fan.user_id } }
    assert_redirected_to artist_fan_url(@artist_fan)
  end

  test "should destroy artist_fan" do
    assert_difference('ArtistFan.count', -1) do
      delete artist_fan_url(@artist_fan)
    end

    assert_redirected_to artist_fans_url
  end
end
