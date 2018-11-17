# == Schema Information
#
# Table name: life_events
#
#  id                     :integer          not null, primary key
#  date                   :date
#  title                  :string
#  life_event_category_id :integer
#  description            :text
#  parent_id              :integer
#  parent_type            :string
#  aasm_state             :string
#  slug                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  duration               :string
#  image_uid              :string
#
# Indexes
#
#  index_life_events_on_slug  (slug)
#

require 'test_helper'

class LifeEventTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    life_event = LifeEvent.new
    assert_not life_event.valid?
    assert_equal [:parent, :life_event_category, :title, :description],
    life_event.errors.keys
  end

  test "should save an life_event with minimal valid fields" do
    parent = artists(:daredevil)
    life_event = parent.life_events.build({
      :date => "2016-06-15",
      :title => 'Marvel Amazement',
      :description => 'This is an event that is held annually for marvel enthusiasts cretors and
        various stake holders alike. Important announcements and developments about different marvel franchises.',
      :life_event_category => life_event_categories(:career),
      })
    assert life_event.valid?
    assert life_event.save

  end

  test "should save a life_event with all fields" do
    parent = artists(:daredevil)
    life_event = parent.life_events.build({
      :date => '2016-06-15',
      :title => 'Marvel Amazement',
      :description => 'This is an event that is held annually for marvel enthusiasts cretors and
        various stake holders alike. Important announcements and developments about different marvel franchises.',
      :life_event_category => life_event_categories(:career),
      duration_time: "2",
      duration_period: "Years"
    })

      assert life_event.valid?
      assert life_event.save
  end

  test "unique title per parent" do
    parent = artists(:daredevil)
    life_event = parent.life_events.build({
      :date => '2016-06-15',
      :title => 'Birthday',
      :description => 'My second birthday',
      :life_event_category => life_event_categories(:career),
      duration_time: "2",
      duration_period: "Years"
    })

    assert_not life_event.valid?
    assert life_event.errors.full_messages.first == "Title has already been taken"

  end

  test "allows non-unique title across parents" do
    parent = artists(:mark_steven_johnson)
    life_event = parent.life_events.build({
      :date => '2016-06-15',
      :title => 'Birthday',
      :description => 'My second birthday',
      :life_event_category => life_event_categories(:career),
      duration_time: "2",
      duration_period: "Years"
    })

    assert life_event.valid?
    assert life_event.save
  end


end
