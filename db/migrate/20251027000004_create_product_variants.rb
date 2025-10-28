# frozen_string_literal: true

class CreateProductVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, default: 0, null: false
      t.string :variant_name, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :product_variants, :sku, unique: true
    add_index :product_variants, :discarded_at
  end
end
