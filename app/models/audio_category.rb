# == Schema Information
#
# Table name: audio_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AudioCategory < ApplicationRecord
  has_many :songs
  validates :name, presence: true , uniqueness: true
end
