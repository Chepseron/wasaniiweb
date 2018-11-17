# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  name        :string
#  url         :string
#  parent_id   :integer
#  parent_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    link = Link.new
    assert_not link.valid?
    assert_equal [:parent, :url],
    link.errors.keys
  end

  test "should save an link with minimal valid fields" do
    parent = businesses(:shield)
    link = parent.links.build({
      :url => "http://steelbrain.me/",
      })
    assert link.valid?
    assert link.save
  end

  test "should not save a url with incorrect format" do
    parent = businesses(:shield)
    link = parent.links.build({
      :url => "steelbrain.me/",
      })
    assert_not link.valid?
    link.errors.keys
  end
end
