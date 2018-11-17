# == Schema Information
#
# Table name: productions
#
#  id                     :integer          not null, primary key
#  cover_picture_uid      :string
#  production_category_id :integer
#  title                  :string
#  language_id            :integer
#  running_time           :integer
#  release_date           :date
#  synopsis               :text
#  director_id            :integer
#  production_company_id  :integer
#  trailer_url            :string
#  parent_id              :integer
#  parent_type            :string
#  aasm_state             :string
#  slug                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_productions_on_slug  (slug)
#

require 'test_helper'

class ProductionTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    production = Production.new
    assert_not production.valid?
    assert_equal [:parent, :production_category, :language, :director, :production_company, :name, :running_time, :synopsis],
    production.errors.keys
  end

  test 'should save with valid keys' do
    parent = artists(:daredevil)
    production = parent.productions.build({
      name: "DareDevil",
      production_category: production_categories(:movie),
      language: languages(:english),
      director: artists(:mark_steven_johnson),
      production_company: businesses(:marvel_studios),
      running_time: 123,
      synopsis: "Matt Murdock is a blind lawyer in New York City's Hell's Kitchen neighborhood,
        where he runs a firm with best friend Franklin 'Foggy' Nelson. As a child, Matt was
        blinded by a toxic waste spill. The accident enhanced Matt's other senses and gave
        him sonar to 'see' via sonic vibrations. Matt's father, boxer Jack 'The Devil', was
        killed after refusing to turn in a fixed fight for the mobster who had employed him
        earlier. After his father's death, Matt promised to stop all crime that controlled
        Hell's Kitchen, New York as the vigilante crime-fighter 'Daredevil'."
      })
      assert production.valid?
      assert production.save
  end
end
