require 'test_helper'

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should log in and persist correct user" do
    post admin_login_path, params: { sessions:
      {
        email: admins(:hawkeye).email,
        password: 'password',
      }
    }
    assert_not_nil session['admin_id']
    assert_redirected_to admin_dashboard_path
  end

  test "shouldn't log in and persist wrong user" do
    post admin_login_path, params: { sessions:
      {
        email: users(:spiderman).email,
        password: 'password1',
      }
    }

    assert_nil session['admin_id']
  end
end
