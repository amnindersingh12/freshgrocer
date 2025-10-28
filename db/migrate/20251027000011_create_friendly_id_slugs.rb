# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[7.1]
  def change
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           null: false
      t.integer  :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 50
      t.string   :scope
      t.datetime :created_at
    end

    add_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
    add_index :friendly_id_slugs, %i[slug sluggable_type], unique: true
    add_index :friendly_id_slugs, %i[slug sluggable_type scope], unique: true
  end
end
