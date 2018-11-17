# == Schema Information
#
# Table name: suggested_updates
#
#  id          :integer          not null, primary key
#  content     :text
#  parent_id   :integer
#  parent_type :string
#  closed      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SuggestedUpdate < ApplicationRecord
  belongs_to :parent, polymorphic: true

  validates_presence_of :content
end
