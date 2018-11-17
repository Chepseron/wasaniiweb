# == Schema Information
#
# Table name: award_categories
#
#  id             :integer          not null, primary key
#  name           :string
#  award_id       :integer
#  accepts_entity :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#

class AwardCategory < ApplicationRecord
  extend FriendlyId
  include PgSearch

  multisearchable against: %i(name)

  friendly_id :name, use: [:slugged, :history]

  belongs_to :award
  has_many :nominees, :dependent => :destroy
  validates_presence_of :name
  validates :name, uniqueness: { scope: :award_id,
      message: "This category has already been added" }


  default_scope { order(:name) }
end
