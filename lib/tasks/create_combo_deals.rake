namespace :combo_deals do
  desc "Create combo deal products with discounted prices"
  task create: :environment do
    puts "Creating combo deals..."

    variants = ProductVariant.joins(:product).limit(8)

    variants.each_with_index do |variant, index|
      original_price = variant.price
      discount_price = (original_price * (0.7 + (index * 0.03))).round(2)

      variant.update(
        is_combo_deal: true,
        compare_at_price: original_price,
        price: discount_price
      )

      puts "✓ Updated #{variant.product.name} - #{variant.variant_name}: Was $#{original_price}, Now $#{discount_price}"
    end

    puts ""
    puts "✅ Successfully created #{variants.count} combo deals!"
  end
end
