class CreateCollectionTypes < ActiveRecord::Migration[5.0]
  def up
    create_table :collection_types do |t|
      t.string :name

      t.timestamps
    end
    %w(Music Photos/Art Productions Books).sort.each{|name| CollectionType.create! name: name}
  end

  def down
    drop_table :collection_types
  end
end
