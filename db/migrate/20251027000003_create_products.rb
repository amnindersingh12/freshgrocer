# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :brand, null: false
      t.references :category, null: false, foreign_key: true
      t.string :slug, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :name
    add_index :products, :brand
    add_index :products, :discarded_at
  end
end
