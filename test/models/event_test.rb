# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  type_id     :integer
#  description :text
#  charges     :string
#  venue_id    :integer
#  date        :date
#  aasm_state  :string
#  parent_id   :integer
#  parent_type :string
#  image_uid   :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  time        :string
#  featured    :boolean
#  enddate     :date
#  url         :string
#
# Indexes
#
#  index_events_on_slug  (slug)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    event = Event.new
    assert_not event.valid?
    assert_equal [:parent, :type, :venue, :name, :description, :charges, :date],
    event.errors.keys
  end

  test "should save an event with minimal valid fields" do
    parent = artists(:daredevil)
    event = parent.events.build({
      :name => 'Marvel Con',
      :type => industries(:film),
      :description => 'This is an event that is held annually for marvel enthusiasts cretors and
        various stake holders alike. Important announcements and developments about different marvel franchises.',
      :charges => 500,
      venue: businesses(:oscorp),
      date: Date.today
    })
    assert event.valid?
    assert event.save
  end
end
