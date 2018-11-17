# == Schema Information
#
# Table name: audio_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AudioCategoryTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    audio_category = AudioCategory.new
    assert_not audio_category.valid?
    assert_equal [:name], audio_category.errors.keys
  end

  test "should not allow duplicate names" do
    audio_category = AudioCategory.new(name: 'Sample')
    assert_not audio_category.valid?
    assert_equal [:name], audio_category.errors.keys
    assert_equal(audio_category.errors.full_messages[0],"Name has already been taken")
  end

  test "should save valid audio_category" do
    audio_category = AudioCategory.new(name: 'Virtual')
    assert audio_category.valid?
    assert audio_category.save
  end
end
