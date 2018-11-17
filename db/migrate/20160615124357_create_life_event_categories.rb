class CreateLifeEventCategories < ActiveRecord::Migration[5.0]
  def up
    create_table :life_event_categories do |t|
      t.string :name

      t.timestamps
    end
    %w(Personal Education/School Career Launch/Release Awards/Nominations Recognition).each{|name| LifeEventCategory.create! name: name}
  end

  def down
    drop_table :life_event_categories
  end
end


