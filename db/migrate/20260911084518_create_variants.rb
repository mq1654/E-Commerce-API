class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku, null: false
      t.integer :stock, null: false, default: 0
      t.decimal :price, null: false

      t.timestamps
    end
    add_index :variants, :sku, unique: true
  end
end
