# == Schema Information
#
# Table name: site_ads
#
#  id                  :integer          not null, primary key
#  name                :string
#  image_uid           :string
#  script              :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  site_ad_position_id :integer
#  active              :boolean          default(TRUE)
#

require 'test_helper'

class SiteAdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site_ad = site_ads(:one)
  end

  test "should get index" do
    get site_ads_url
    assert_response :success
  end

  test "should get new" do
    get new_site_ad_url
    assert_response :success
  end

  test "should create site_ad" do
    assert_difference('SiteAd.count') do
      post site_ads_url, params: { site_ad: { image_uid: @site_ad.image_uid, name: @site_ad.name, script: @site_ad.script } }
    end

    assert_redirected_to site_ad_url(SiteAd.last)
  end

  test "should show site_ad" do
    get site_ad_url(@site_ad)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_ad_url(@site_ad)
    assert_response :success
  end

  test "should update site_ad" do
    patch site_ad_url(@site_ad), params: { site_ad: { image_uid: @site_ad.image_uid, name: @site_ad.name, script: @site_ad.script } }
    assert_redirected_to site_ad_url(@site_ad)
  end

  test "should destroy site_ad" do
    assert_difference('SiteAd.count', -1) do
      delete site_ad_url(@site_ad)
    end

    assert_redirected_to site_ads_url
  end
end
