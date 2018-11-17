# == Schema Information
#
# Table name: nominees
#
#  id                :integer          not null, primary key
#  award_category_id :integer
#  recipient_id      :integer
#  recipient_type    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  year              :string
#  rank_id           :integer          default(4)
#

class Nominee < ApplicationRecord
  belongs_to :award_category
  belongs_to :recipient, polymorphic: true
  belongs_to :rank, optional: true
  cattr_accessor :current_category
  validates_presence_of :year

  def nominee_category
    award_category.name
  end

  def name
    if recipient.is_a?(Artist)
      return recipient.profile_name
    else
      return recipient.title
    end
  end

  def nominee_name
    recipient.title unless recipient.nil?
  end

  def nominee_name=(val)
    industry = Nominee.current_category.award.industry
    nominee = case industry.name
      when "Art and Design"
        PhotoArt.find_by_title(val)
      when "Fashion"
        PhotoArt.find_by_title(val)
      when "Film, TV and Theater"
        Production.find_by_title(val)
      when "Literature"
        Book.find_by_title(val)
      when "Music"
        Song.find_by_title(val)
      end || Artist.find_by_profile_name(val)

      unless nominee.nil?
        self.recipient = nominee
      end
  end

end
