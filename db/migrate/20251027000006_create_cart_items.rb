# frozen_string_literal: true

class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.integer :quantity, default: 1, null: false

      t.timestamps
    end

    add_index :cart_items, %i[cart_id product_variant_id], unique: true
  end
end
