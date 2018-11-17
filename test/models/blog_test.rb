# == Schema Information
#
# Table name: blogs
#
#  id          :integer          not null, primary key
#  title       :string
#  content     :text
#  date        :date
#  parent_id   :integer
#  parent_type :string
#  aasm_state  :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image_uid   :string
#
# Indexes
#
#  index_blogs_on_slug  (slug)
#

require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    blog = Blog.new
    assert_not blog.valid?
    assert_equal [:parent, :title, :date, :content],
    blog.errors.keys
  end

  test "should save a blog with all fields" do
    parent = artists(:daredevil)
    blog = parent.blogs.build({
      :title => "DC COMICS",
      date: Date.today,
      :content => "This is an event that is held annually for marvel enthusiasts cretors and
        various stake holders alike. Important announcements and developments about different DC comics franchises.",
    })
    assert blog.valid?
    assert blog.save
  end
end
