class CreateAudioCategories < ActiveRecord::Migration[5.0]
  def up
    create_table :audio_categories do |t|
      t.string :name

      t.timestamps
    end

    %w(Sample Full).each{|name| AudioCategory.create! name: name}
  end

  def down 
  	drop_table :audio_categories
  end
end
