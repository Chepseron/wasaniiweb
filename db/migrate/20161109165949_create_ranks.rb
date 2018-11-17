class CreateRanks < ActiveRecord::Migration[5.0]
  def up
    create_table :ranks do |t|
      t.string :name

      t.timestamps
    end

    ['Winner', '1st Runner Up', '2nd Runner Up'].each{|name| Rank.create! name: name}
  end

  def down
    drop_table :ranks
  end
end
