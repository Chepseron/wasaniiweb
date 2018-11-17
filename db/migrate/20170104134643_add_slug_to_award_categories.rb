class AddSlugToAwardCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :award_categories, :slug, :string
  end
end
