class CreateIndustries < ActiveRecord::Migration[5.0]
  def up
    create_table :industries do |t|
      t.string :name

      t.timestamps
    end
    ["Art and Design", "Fashion", "Film, TV and Theater", "Literature", "Music"].each{|name| Industry.create! name: name}
  end

  def down
    drop_table :industries
  end
end


