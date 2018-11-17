# == Schema Information
#
# Table name: impressions
#
#  id          :integer          not null, primary key
#  entity_id   :integer
#  entity_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Impression < ApplicationRecord
  belongs_to :entity, polymorphic: :true
  belongs_to :artist, foreign_key: :entity_id, foreign_type: :entity_type, class_name: 'Artist', optional: true
end

