# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin_role_id   :integer
#  deactivated     :boolean
#

require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    admin = Admin.new
    assert_not admin.valid?
    assert_equal [:password, :name, :email], admin.errors.keys
  end

  test "should save valid admin" do
    admin = Admin.new(name: 'Peter Pan', email: 'peter@pan.com', password: 'password', password_confirmation: 'password')
    assert admin.valid?
    assert admin.save
  end

  test "should fail if an editor doesn't have an industry selected" do
    admin = Admin.new(name: 'Peter Pan', email: 'peter@pan.com', password: 'password',
      password_confirmation: 'password', editor: true)
    assert_not admin.valid?
    assert_equal [:industries], admin.errors.keys
  end

  test "should pass if an editor has at least industry selected" do
    admin = Admin.new(name: 'Peter Pan', email: 'peter@pan.com', password: 'password',
      password_confirmation: 'password', editor: true, industries: [industries(:music), industries(:film)])
    assert admin.valid?
    assert admin.save
  end
end
