# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    language = Language.new
    assert_not language.valid?
    assert_equal [:name], language.errors.keys
  end

  test "should not allow duplicate names" do
    language = Language.new(name: 'Swahili')
    assert_not language.valid?
    assert_equal [:name], language.errors.keys
    assert_equal(language.errors.full_messages[0],"Name has already been taken")
  end

  test "should save valid language" do
    language = Language.new(name: 'French')
    assert language.valid?
    assert language.save
  end
end
