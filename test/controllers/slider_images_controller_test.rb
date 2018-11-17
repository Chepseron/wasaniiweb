# == Schema Information
#
# Table name: slider_images
#
#  id               :integer          not null, primary key
#  image_uid        :string
#  active           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  left_content     :text
#  right_content    :text
#  centered_content :text
#  position         :integer
#

require 'test_helper'

class SliderImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @slider_image = slider_images(:one)
  end

  test "should get index" do
    get slider_images_url
    assert_response :success
  end

  test "should get new" do
    get new_slider_image_url
    assert_response :success
  end

  test "should create slider_image" do
    assert_difference('SliderImage.count') do
      post slider_images_url, params: { slider_image: { image_uid: @slider_image.image_uid } }
    end

    assert_redirected_to slider_image_url(SliderImage.last)
  end

  test "should show slider_image" do
    get slider_image_url(@slider_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_slider_image_url(@slider_image)
    assert_response :success
  end

  test "should update slider_image" do
    patch slider_image_url(@slider_image), params: { slider_image: { image_uid: @slider_image.image_uid } }
    assert_redirected_to slider_image_url(@slider_image)
  end

  test "should destroy slider_image" do
    assert_difference('SliderImage.count', -1) do
      delete slider_image_url(@slider_image)
    end

    assert_redirected_to slider_images_url
  end
end
