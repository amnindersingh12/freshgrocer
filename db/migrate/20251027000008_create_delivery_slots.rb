# frozen_string_literal: true

class CreateDeliverySlots < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_slots do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :is_available, default: true, null: false

      t.timestamps
    end

    add_index :delivery_slots, :start_time
    add_index :delivery_slots, :is_available
  end
end
