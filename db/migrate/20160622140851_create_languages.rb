class CreateLanguages < ActiveRecord::Migration[5.0]
  def up
    create_table :languages do |t|
      t.string :name

      t.timestamps
    end
    %w(English French Sheng Kiswahili).each{|name| Language.create! name: name}
  end

  def down
    drop_table :languages
  end
end
