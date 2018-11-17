# == Schema Information
#
# Table name: news_stories
#
#  id          :integer          not null, primary key
#  title       :string
#  date        :date
#  content     :text
#  parent_type :string
#  parent_id   :integer
#  aasm_state  :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image_uid   :string
#
# Indexes
#
#  index_news_stories_on_slug  (slug)
#

require 'test_helper'

class NewsStoryTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    news_story = NewsStory.new
    assert_not news_story.valid?
    assert_equal [:parent, :title, :date, :content],
    news_story.errors.keys
  end

  test "should save a news story with all  fields" do
    parent = artists(:daredevil)
    news_story = parent.news_stories.build({
      :title => "DC COMICS",
      date: Date.today,
      :content => "This is an event that is held annually for marvel enthusiasts cretors and
        various stake holders alike. Important announcements and developments about different DC comics franchises.",
    })
    assert news_story.valid?
    assert news_story.save
  end
end
