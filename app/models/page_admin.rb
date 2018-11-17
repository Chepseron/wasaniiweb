# == Schema Information
#
# Table name: page_admins
#
#  user_id        :integer
#  page_id        :integer
#  page_type      :string
#  admin_accepted :boolean          default(FALSE)
#
# Indexes
#
#  index_page_admins_on_page_id_and_user_id  (page_id,user_id)
#  index_page_admins_on_user_id_and_page_id  (user_id,page_id)
#

class PageAdmin < ApplicationRecord
  belongs_to :user
  belongs_to :page, polymorphic: true
end
