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

class BusinessCategoryTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    business_category = BusinessCategory.new
    assert_not business_category.valid?
    assert_equal [:name], business_category.errors.keys
  end

  test "should not allow duplicate names" do
    business_category = BusinessCategory.new(name: 'Park')
    assert_not business_category.valid?
    assert_equal [:name], business_category.errors.keys
    assert_equal(business_category.errors.full_messages[0],"Name has already been taken")
  end

  test "should save valid business_category" do
    business_category = BusinessCategory.new(name: 'Open Stage')
    assert business_category.valid?
    assert business_category.save
  end
end
