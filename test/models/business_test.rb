# == Schema Information
#
# Table name: businesses
#
#  id                   :integer          not null, primary key
#  name                 :string
#  country              :string
#  logo_uid             :string
#  company_info         :text
#  latitude             :float
#  longitude            :float
#  business_category_id :integer
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  slug                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  physical_location    :text
#  phone_number         :string
#  email                :string
#  working_hours        :string
#  featured             :boolean
#  banned               :boolean
#
# Indexes
#
#  index_businesses_on_parent_id    (parent_id)
#  index_businesses_on_parent_type  (parent_type)
#  index_businesses_on_slug         (slug) UNIQUE
#

require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  test 'should have necessary validators for no parent' do
    business = Business.new

    assert_not business.valid?
    assert_equal [:name], business.errors.keys
  end

  test "should have the necessary required validators for admin as parent" do
    admin = admins(:hawkeye)
    business = admin.businesses.build

    assert_not business.valid?
    assert_equal  [:name, :country, :latitude, :longitude], business.errors.keys
  end

  test "should have necessary validators for user as parent" do
    user = users(:spiderman)
    business = user.businesses.build

    assert_not business.valid?
    assert_equal [:name, :country, :latitude, :longitude, :logo, :company_info, :business_category, :industries],
    business.errors.keys
  end

  test "should not accept duplicate name" do
    user = users(:spiderman)
    business = user.businesses.build(name: 'Oscorp', country: 'Kenya', latitude: '-1.0934323434',
      longitude: '0.834368326', logo: 'my-logo-url', company_info: 'a small blurb about the company',
      business_category: business_categories(:restaurant), industries: [industries(:music), industries(:film)])

    assert_not business.valid?
    assert_equal [:name], business.errors.keys
  end

  test "should accept all correct values" do
    user = users(:spiderman)
    business = user.businesses.build(name: 'Carnivore', country: 'Kenya', latitude: '-1.0934323434',
      longitude: '0.834368326', logo: 'my-logo-url', company_info: 'a small blurb about the company',
      business_category: business_categories(:restaurant), industries: [industries(:music), industries(:film)])

    assert business.valid?
    assert business.save
  end
end
