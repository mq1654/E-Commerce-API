class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :brand
      t.decimal :base_price, null: false
      t.references :category, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
