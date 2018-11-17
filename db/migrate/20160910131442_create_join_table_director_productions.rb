class CreateJoinTableDirectorProductions < ActiveRecord::Migration[5.0]
  def change
    create_table :directors_productions, :id => false do |t|
      t.integer :artist_id
      t.integer :production_id
    end
  end
end
