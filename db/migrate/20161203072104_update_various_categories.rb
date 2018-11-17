class UpdateVariousCategories < ActiveRecord::Migration[5.0]
  def change
    drop_table :production_categories
    drop_table :business_categories

    create_table :business_categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :production_categories do |t|
      t.string :name

      t.timestamps
    end

    ['Music Studios', 'Production Companies', 'Fashion House','Art Studio', 'Theater Company', 'Publisher', 'Performance Space'].each{|name| BusinessCategory.create!(name: name)}


    ['Movie', 'Play', 'Series', 'Demo Reel', 'Short Film','Animation'].each{|name| ProductionCategory.create! name: name}
  end
end
