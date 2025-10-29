class AddComboDealFieldsToProductVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :product_variants, :compare_at_price, :decimal, precision: 10, scale: 2
    add_column :product_variants, :is_combo_deal, :boolean, default: false, null: false
    add_index :product_variants, :is_combo_deal
  end
end
