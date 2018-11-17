class CreateProductionCategories < ActiveRecord::Migration[5.0]
  def up
    create_table :production_categories do |t|
      t.string :name

      t.timestamps
    end

    ['Movie', 'Play', 'Series', 'Demo Reel'].each{|name| ProductionCategory.create! name: name}
  end

  def down
    drop_table :production_categories
  end
end
