# == Schema Information
#
# Table name: artist_specialities
#
#  id          :integer          not null, primary key
#  name        :string
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ArtistSpeciality < ApplicationRecord

  has_and_belongs_to_many :artists
  belongs_to :industry
  validates :name, presence: true , uniqueness: { scope: :industry,
    message: "already declared within this industry" }
end
