# == Schema Information
#
# Table name: artists
#
#  id                   :integer          not null, primary key
#  profile_name         :string
#  name                 :string
#  contact_phone_number :string
#  contact_email        :string
#  gender               :string
#  birthday        :date
#  country_of_birth     :string
#  profile_pic_uid      :string
#  introduction         :text
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  aasm_state           :string           default("new_profile")
#  height               :string
#  weight               :string
#  bust                 :string
#  hips                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test "can create a new admin" do
    admin = admins(:hawkeye)
    admin_login(admin)

    post admin_admins_path, params: {
      name:"Admin Guy", email: 'admin@wasaniimedia.com'
    }
  end
end
