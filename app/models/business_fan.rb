# == Schema Information
#
# Table name: business_fans
#
#  id          :integer          not null, primary key
#  business_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BusinessFan < ApplicationRecord
  belongs_to :business, inverse_of: :business_fans
  belongs_to :user
end
