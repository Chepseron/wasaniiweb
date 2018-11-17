# == Schema Information
#
# Table name: industries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Industry < ApplicationRecord
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :admins
  has_many :artist_specialities
  has_many :awards

  has_many :events, foreign_key: :type_id
  has_many :collection_albums, foreign_key: :type_id

  has_and_belongs_to_many :users

  validates :name, presence: true , uniqueness: true
end
