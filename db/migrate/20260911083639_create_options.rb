class CreateOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :options do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
