require 'test_helper'

class Admin::AdminBusinessHappyPathTest < Minitest::Capybara::Spec
  describe "the admin user" do
    it "can add a business" do
      admin = Admin.find_by_email('hawkeye@marvelcomics.com')
      admin_login(admin)

      click_on "Create Business"
      fill_in 'business_name', with: 'Stark Industries'

      attach_file 'business_logo', './test/attachments/blue-pools.jpg'
      page.find('#business_latitude', visible: false).set '1.007834'
      page.find('#business_longitude', visible: false).set '-0.007834'

      select "Kenya", from: :business_country

      select 'Office', from: :business_business_category_id

      click_button 'Create Business'
      assert page.has_content? 'Business was successfully created.'

    end
  end

  it 'can see the list of unverified businesses' do
    admin = Admin.find_by_email('hawkeye@marvelcomics.com')
    admin_login(admin)
    assert page.has_content? 'Newly Registered Businesses'
  end

  it 'can verify a new business' do
    admin = Admin.find_by_email('hawkeye@marvelcomics.com')
    admin_login(admin)

    within ".new-businesses" do
      first(:link,'view').click
    end

    assert page.has_content? 'Verified?:false'
    click_link "edit"
    check 'Check to Verify'
    click_button 'Update Business'
    assert page.has_content? 'Verified?:true'

  end


end
