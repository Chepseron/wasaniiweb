class AddAasmStateToAwards < ActiveRecord::Migration[5.0]
  def change
    add_column :awards, :aasm_state, :string
  end
end
