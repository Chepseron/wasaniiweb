# == Schema Information
#
# Table name: artist_fans
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArtistFan < ApplicationRecord
  belongs_to :artist, inverse_of: :artist_fans
  belongs_to :user
end
