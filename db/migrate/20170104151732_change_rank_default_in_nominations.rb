class ChangeRankDefaultInNominations < ActiveRecord::Migration[5.0]
  def change
    rank = Rank.create! name: 'Unassigned'
    change_column :nominees, :rank_id, :integer, default: rank.id
  end
end
