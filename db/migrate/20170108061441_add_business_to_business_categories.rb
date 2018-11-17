class AddBusinessToBusinessCategories < ActiveRecord::Migration[5.0]
  def up
    ["Business"].each{|name| BusinessCategory.create!(name: name)}
  end
end
