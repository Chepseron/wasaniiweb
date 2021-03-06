# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#



class Country < ApplicationRecord
  has_many :users, :dependent => :destroy
  has_many :songs, :dependent => :destroy
  has_many :books, :dependent => :destroy
end
