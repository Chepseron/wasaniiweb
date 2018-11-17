# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  name        :string
#  url         :string
#  parent_id   :integer
#  parent_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Link < ApplicationRecord
  belongs_to :parent, polymorphic: :true
  validates_presence_of :name, :url
  validates_format_of :url, :with => URI::regexp(%w(http https)), message: 'Please use a valid link beginning with http/https'
end
