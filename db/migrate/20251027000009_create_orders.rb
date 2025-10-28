# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.references :delivery_slot, null: false, foreign_key: true
      t.string :status, default: 'pending', null: false
      t.string :payment_status, default: 'unpaid', null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :payment_status
    add_index :orders, :created_at
  end
end
