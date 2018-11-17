class PopulateBusinessCategories < ActiveRecord::Migration[5.0]
  def up
    drop_table :business_categories

    create_table :business_categories do |t|
      t.string :name

      t.timestamps
    end

    ['Music Studios', 'Production Companies', 'Fashion House','Art Studio',
      'Theater Company', 'Publishing Company', 'Performance Space', "Restaurant",
      "Hotel", "Club", "Park", "Hall"].each{|name| BusinessCategory.create!(name: name)}
  end

  def down
    drop_table :business_categories

    create_table :business_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
