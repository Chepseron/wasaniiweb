require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should log in and persist correct user" do
    post login_path, params: { sessions:
      {
        email: users(:spiderman).email,
        password: 'password',
      }
    }

    assert_not_nil session['user_id']
    assert_redirected_to dashboard_user_path(users(:spiderman))
  end

  test "should rediect to edit page if info is missing" do
    post login_path, params: { sessions:
      {
        email: users(:ironman).email,
        password: 'password',
      }
    }

    assert_not_nil session['user_id']
    assert_redirected_to dashboard_user_path(users(:ironman))
  end

  test "shouldn't log in and persist wrong user" do
    post login_path, params: { sessions:
      {
        email: users(:spiderman).email,
        password: 'password1',
      }
    }

    assert_nil session['user_id']
  end

  test 'allows login from 3rd party apps and redirects to edit' do
    #here we assume that not all information will be collected from the omniauth
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                        :authenticity_token => 'form_authenticity_token',
                        :state=>"84399fdbd3903527c7b90e2c313793edcd84d7e2368af6a9",
                        :code => "4/ByplxuZmYMTKQ1V_mVbQT1Vx_3O8JvV15H083Dvv5_k",
                        :provider => 'facebook',
                        :uid => '1234567',
                        :info => {
                          :email => 'joe@bloggs.com',
                          :name => 'Joe Bloggs',
                          :image => 'http://graph.facebook.com/1234567/picture?type=square',
                          :location => 'Palo Alto, California'
                        },
                        :extra => {
                          :raw_info => {
                            :birthday => "12/24/1976"
                          }
                        }
                      })

    OmniAuth.config.test_mode = true
    assert_difference 'User.count' do
      get omniauth_create_path('facebook'), OmniAuth.config.mock_auth['facebook']
    end

    assert assigns[:user].email_confirmed?
    assert_redirected_to edit_user_path(assigns[:user])
  end
end
