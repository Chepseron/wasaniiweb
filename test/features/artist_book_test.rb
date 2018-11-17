require 'test_helper'

class ArtistBookTest < Minitest::Capybara::Spec
	describe "an artist" do
		it "can add a book entity" do
			artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)
			visit artist_path(artist)

			assert page.has_link? "Add A Book"
  		click_link "Add A Book"
  		assert page.has_content? "New book"

  		fill_in :book_title, with: "Book Thief"
      attach_file :book_cover_pic, './test/attachments/blue-pools.jpg'
  		fill_in :book_intro_text, with: "The Book Thief is a novel by Australian author Markus Zusak.
        First published in 2005, the book won several awards and was listed on The New York Times
        Best Seller list for 375 weeks"
			fill_in :book_summary, with: "After her brother's death, Liesel arrives in a distraught
        state at the home of her new foster parents, Hans and Rosa Hubermann. During her time
        there, she is exposed to the horror of the Nazi regime and struggles to find a way to
        preserve the innocence of her childhood in the midst of her destructive surroundings.
        As the political situation in Germany deteriorates, her foster parents hide a Jewish
        man named Max, putting the family in danger."
			select 'Kenya', from: :book_country

  		select 23, from: :book_publishing_date_3i
  		select 'November', from: :book_publishing_date_2i
  		select 2016, from: :book_publishing_date_1i

			click_button "Create Book"

			assert page.has_content? 'books#show'
		end
	end
end
