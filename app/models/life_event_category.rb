# == Schema Information
#
# Table name: life_event_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LifeEventCategory < ApplicationRecord
  has_many :life_events
end
