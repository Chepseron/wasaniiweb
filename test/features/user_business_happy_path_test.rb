
require 'test_helper'

class UserBusinessHappyPathTest < Minitest::Capybara::Spec
  describe "a user" do
    it 'can add a business' do
      user = User.find_by_email('spiderman@marvelcomics.com')
      login(user)

      assert page.has_link? 'Add Business'
      click_link 'Add Business'

      assert page.has_content? 'New business'

      fill_in 'business_name', with: 'Daily Bugle'
      attach_file :business_logo, './test/attachments/blue-pools.jpg'
      select "Kenya", from: :business_country

      fill_in :business_company_info, with: "Founded in 1897, the Daily Bugle
        was purchased a few decades after its inception by businessman
        William Walter Goodman, who prized selfless human achievement
        above all else and who lent his name to the building the newspaper called home."

      check 'Film'
      page.find('#business_latitude', visible: false).set '1.007834'
      page.find('#business_longitude', visible: false).set '-0.007834'

      select 'Office', from: :business_business_category_id

      click_button 'Create Business'
      assert page.has_content? 'Business was successfully created.'
    end

    it 'can claim a business' do

    end
  end

end
