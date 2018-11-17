# == Schema Information
#
# Table name: books
#
#  id                    :integer          not null, primary key
#  title                 :string
#  isbn                  :string
#  cover_pic_uid         :string
#  summary               :text
#  publishing_company_id :integer
#  publishing_date       :date
#  parent_id             :integer
#  parent_type           :string
#  aasm_state            :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_books_on_slug  (slug)
#

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    book = Book.new
    assert_not book.valid?
    assert_equal [:parent, :title, :cover_pic, :summary, :country, :publishing_date],
    book.errors.keys
  end

  test "should save a book with all fields and parent as artist" do
    parent = artists(:daredevil)
    book = parent.books.build({
      title: 'Civil War',
      cover_pic_uid: 'cover pic',
      summary: "The landscape of the Marvel Universe is changing,
        and it's time to choose: Whose side are you on? A conflict has been
        brewing from more than a year, threatening to pit friend against friend,
        brother against brother - and all it will take is a single misstep to
        cost thousands their lives and ignite the fuse.",
      publishing_date: 'April 11, 2007'.to_date ,
      country: 'USA'
    })
    assert book.valid?
    assert book.save
  end
end
