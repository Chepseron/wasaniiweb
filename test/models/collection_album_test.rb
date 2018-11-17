# == Schema Information
#
# Table name: collection_albums
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  visible            :boolean
#  parent_id          :integer
#  parent_type        :string
#  collection_type_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_pic_uid      :string
#  album_date         :date
#  slug               :string
#  aasm_state         :string
#
# Indexes
#
#  index_collection_albums_on_slug  (slug)
#

require 'test_helper'

class CollectionAlbumTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    collection_album = CollectionAlbum.new
    assert_not collection_album.valid?
    assert_equal [:parent, :type, :name],
    collection_album.errors.keys
  end

  test 'should save with valid keys' do
    parent = artists(:daredevil)
    collection_album = parent.collection_albums.build({
      name: "My Music Collection",
      type: industries(:music)
    })

    assert collection_album.valid?
    assert collection_album.save
  end

  test 'collecitons can contain other entities' do
    parent = artists(:daredevil)
    collection_album = parent.collection_albums.build({
      name: "My Music Collection",
      type: industries(:music),
      books: [books(:first_book), books(:second_book)],
      photo_arts: [photo_arts(:first_photo_art), photo_arts(:second_photo_art)],
      productions: [productions(:first_production), productions(:second_production)],
      songs: [songs(:first_song), songs(:second_song)]
    })

    assert collection_album.valid?
    assert collection_album.save
  end
end
