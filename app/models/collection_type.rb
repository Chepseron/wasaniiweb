# == Schema Information
#
# Table name: collection_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CollectionType < ApplicationRecord
  has_many :collection_albums
end
