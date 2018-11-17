# == Schema Information
#
# Table name: industries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class IndustryTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    industry = Industry.new
    assert_not industry.valid?
    assert_equal [:name], industry.errors.keys
  end

  test "should not allow duplicate names" do
    industry = Industry.new(name: 'Music')
    assert_not industry.valid?
    assert_equal [:name], industry.errors.keys
    assert_equal(industry.errors.full_messages[0],"Name has already been taken")
  end

  test "should save valid industry" do
    industry = Industry.new(name: 'Photography')
    assert industry.valid?
    assert industry.save
  end
end
