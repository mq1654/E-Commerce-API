class CreateOptionValues < ActiveRecord::Migration[8.1]
  def change
    create_table :option_values do |t|
      t.references :option, null: false, foreign_key: true
      t.string :value, null: false

      t.timestamps
    end
    add_index :option_values, [ :option_id, :value ], unique: true
  end
end
