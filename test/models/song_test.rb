# == Schema Information
#
# Table name: songs
#
#  id                    :integer          not null, primary key
#  title                 :string
#  description           :text
#  lyrics                :text
#  audio_url             :string
#  audio_category_id     :integer
#  video_url             :string
#  image_uid             :string
#  release_date          :date
#  parent_id             :integer
#  parent_type           :string
#  aasm_state            :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  production_company_id :integer
#
# Indexes
#
#  index_songs_on_slug  (slug)
#

require 'test_helper'

class SongTest < ActiveSupport::TestCase
 	test "should require necessary validators" do
 		song = Song.new
		assert_not song.valid?
		assert_equal [:parent, :audio_category, :name, :audio_url, :country, :release_date],
    	song.errors.keys
 	end

 	test "should save an song with all fields" do
    parent = artists(:daredevil)
    song = parent.songs.build({
      audio_category: audio_categories(:sample),
      country: 'KE',
      name: 'Tom Ford',
      audio_url: 'My String',
      lyrics: 'Hands down got the best flow Sound Im so special Sound boy
        burial This my Wayne Perry flow Yall know nothing about Wayne Perry
        though District of Columbia Guns on your Tumblrs',
      description: 'In 2013, when Toronto mayor Rob Ford was embroiled in
        what seems like dozens of simultaneous scandals, Canadian DJ Steve
        Porter remixed “Tom Ford” incorporating soundbites',
      video_url: 'Watcher now',
      image_uid: 'My Own',
      release_date: Date.today
      })
    assert song.valid?
    assert song.save
  end
end
