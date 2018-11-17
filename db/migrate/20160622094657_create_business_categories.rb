class CreateBusinessCategories < ActiveRecord::Migration[5.0]
  def up
    create_table :business_categories do |t|
      t.string :name

      t.timestamps
    end
    ["Restaurant", "Club", "Park", "Hall"].each{|name| BusinessCategory.create!(name: name)}
  end

  def down
    drop_table :business_categories
  end
end
