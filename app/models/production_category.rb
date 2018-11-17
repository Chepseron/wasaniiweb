# == Schema Information
#
# Table name: production_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProductionCategory < ApplicationRecord
  has_many :productions
end
