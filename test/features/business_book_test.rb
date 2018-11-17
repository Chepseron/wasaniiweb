require 'test_helper'

class  BusinessBookTest < Minitest::Capybara::Spec
	describe "a business" do
		it "can add a book" do
			business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

	    visit business_path(business)

	    assert page.has_link? "Add A Book"
			click_link "Add A Book"
			assert page.has_content? "New book"

			fill_in 'book_title', with: "THE LEGEND OF WONDER WOMAN "
			attach_file :book_cover_pic, './test/attachments/blue-pools.jpg'
			fill_in 'book_summary', with: "Wonder Woman has been making a big splash in the European Theater of Operations, and it’s drawn the notice of Nazi high command—and something even scarier. Plus, Steve Trevor is teaching Diana Prince to fly an airplane, without knowing that his admiration for Wonder Woman is quite awkward for his trainee! "
			select 'Kenya', from: :book_country

  		select 23, from: :book_publishing_date_3i
  		select 'November', from: :book_publishing_date_2i
  		select 2016, from: :book_publishing_date_1i

			click_button "Create Book"

			assert page.has_content? 'books#show'
		end
	end
end
