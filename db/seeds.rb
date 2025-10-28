# frozen_string_literal: true

# Clear existing data
puts 'Clearing existing data...'
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
ProductVariant.with_discarded.destroy_all
Product.with_discarded.destroy_all
Category.destroy_all
Address.destroy_all
DeliverySlot.destroy_all
User.destroy_all

# Create admin user
puts 'Creating admin user...'
admin = User.create!(
  email: 'admin@freshgrocer.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Admin User',
  role: :admin
)

# Create customer user
puts 'Creating customer user...'
customer = User.create!(
  email: 'customer@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'John Doe',
  role: :customer
)

# Create main categories
puts 'Creating categories...'
dairy = Category.create!(name: 'Dairy & Eggs')
fruits = Category.create!(name: 'Fresh Fruits')
vegetables = Category.create!(name: 'Vegetables')
bakery = Category.create!(name: 'Bakery')
beverages = Category.create!(name: 'Beverages')
snacks = Category.create!(name: 'Snacks & Treats')

# Create sub-categories
milk_category = Category.create!(name: 'Milk', parent: dairy)
cheese_category = Category.create!(name: 'Cheese', parent: dairy)
yogurt_category = Category.create!(name: 'Yogurt', parent: dairy)
eggs_category = Category.create!(name: 'Eggs', parent: dairy)

citrus_category = Category.create!(name: 'Citrus Fruits', parent: fruits)
berries_category = Category.create!(name: 'Berries', parent: fruits)

leafy_greens_category = Category.create!(name: 'Leafy Greens', parent: vegetables)
root_vegetables_category = Category.create!(name: 'Root Vegetables', parent: vegetables)

# Create products with variants
puts 'Creating products and variants...'

# Dairy products
milk = Product.create!(
  name: 'Whole Milk',
  description: 'Fresh whole milk from local farms. Rich and creamy with 3.5% fat content.',
  brand: 'FreshFarms',
  category: milk_category
)

ProductVariant.create!([
                         { product: milk, sku: 'MILK-1L-001', price: 3.99, stock_quantity: 100,
                           variant_name: '1 Liter' },
                         { product: milk, sku: 'MILK-2L-001', price: 6.99, stock_quantity: 50,
                           variant_name: '2 Liters' },
                         { product: milk, sku: 'MILK-500ML-001', price: 2.49, stock_quantity: 75,
                           variant_name: '500ml' }
                       ])

cheddar = Product.create!(
  name: 'Aged Cheddar Cheese',
  description: 'Sharp and flavorful aged cheddar cheese. Perfect for sandwiches and cooking.',
  brand: 'CheeseKing',
  category: cheese_category
)

ProductVariant.create!([
                         { product: cheddar, sku: 'CHEDDAR-200G-001', price: 5.99, stock_quantity: 40,
                           variant_name: '200g' },
                         { product: cheddar, sku: 'CHEDDAR-400G-001', price: 10.99, stock_quantity: 25,
                           variant_name: '400g' }
                       ])

greek_yogurt = Product.create!(
  name: 'Greek Yogurt',
  description: 'Thick and creamy Greek yogurt. High in protein, low in fat.',
  brand: 'GreekGods',
  category: yogurt_category
)

ProductVariant.create!([
                         { product: greek_yogurt, sku: 'YOGURT-PLAIN-500G', price: 4.99, stock_quantity: 60,
                           variant_name: 'Plain 500g' },
                         { product: greek_yogurt, sku: 'YOGURT-BERRY-500G', price: 5.49, stock_quantity: 50,
                           variant_name: 'Berry 500g' }
                       ])

# Fruits
apples = Product.create!(
  name: 'Red Apples',
  description: 'Crisp and sweet red apples. Great for snacking or baking.',
  brand: 'OrchardFresh',
  category: fruits
)

ProductVariant.create!([
                         { product: apples, sku: 'APPLE-500G-001', price: 2.99, stock_quantity: 200,
                           variant_name: '500g' },
                         { product: apples, sku: 'APPLE-1KG-001', price: 5.49, stock_quantity: 150,
                           variant_name: '1kg' }
                       ])

bananas = Product.create!(
  name: 'Fresh Bananas',
  description: 'Ripe yellow bananas. Rich in potassium and naturally sweet.',
  brand: 'TropicHarvest',
  category: fruits
)

ProductVariant.create!([
                         { product: bananas, sku: 'BANANA-BUNCH-001', price: 1.99, stock_quantity: 300,
                           variant_name: 'Per Bunch (5-6)' },
                         { product: bananas, sku: 'BANANA-1KG-001', price: 2.99, stock_quantity: 200,
                           variant_name: '1kg' }
                       ])

oranges = Product.create!(
  name: 'Navel Oranges',
  description: 'Sweet and juicy navel oranges. Perfect for fresh juice.',
  brand: 'CitrusGarden',
  category: citrus_category
)

ProductVariant.create!([
                         { product: oranges, sku: 'ORANGE-1KG-001', price: 3.99, stock_quantity: 180,
                           variant_name: '1kg' },
                         { product: oranges, sku: 'ORANGE-2KG-001', price: 7.49, stock_quantity: 100,
                           variant_name: '2kg' }
                       ])

strawberries = Product.create!(
  name: 'Fresh Strawberries',
  description: 'Sweet and fragrant strawberries. Locally grown.',
  brand: 'BerryBest',
  category: berries_category
)

ProductVariant.create!([
                         { product: strawberries, sku: 'STRAWBERRY-250G', price: 4.99, stock_quantity: 80,
                           variant_name: '250g' },
                         { product: strawberries, sku: 'STRAWBERRY-500G', price: 8.99, stock_quantity: 60,
                           variant_name: '500g' }
                       ])

# Vegetables
carrots = Product.create!(
  name: 'Fresh Carrots',
  description: 'Crunchy and sweet carrots. Rich in vitamin A.',
  brand: 'GardenProduce',
  category: root_vegetables_category
)

ProductVariant.create!([
                         { product: carrots, sku: 'CARROT-500G-001', price: 1.99, stock_quantity: 150,
                           variant_name: '500g' },
                         { product: carrots, sku: 'CARROT-1KG-001', price: 3.49, stock_quantity: 120,
                           variant_name: '1kg' }
                       ])

spinach = Product.create!(
  name: 'Baby Spinach',
  description: 'Tender baby spinach leaves. Perfect for salads and smoothies.',
  brand: 'GreenLeaf',
  category: leafy_greens_category
)

ProductVariant.create!([
                         { product: spinach, sku: 'SPINACH-200G-001', price: 3.49, stock_quantity: 90,
                           variant_name: '200g' },
                         { product: spinach, sku: 'SPINACH-500G-001', price: 7.99, stock_quantity: 50,
                           variant_name: '500g' }
                       ])

# Bakery
bread = Product.create!(
  name: 'Whole Wheat Bread',
  description: 'Fresh whole wheat bread. Baked daily.',
  brand: 'BakeryFresh',
  category: bakery
)

ProductVariant.create!([
                         { product: bread, sku: 'BREAD-WW-400G', price: 2.99, stock_quantity: 100,
                           variant_name: '400g Loaf' },
                         { product: bread, sku: 'BREAD-WW-800G', price: 5.49, stock_quantity: 60,
                           variant_name: '800g Loaf' }
                       ])

croissants = Product.create!(
  name: 'Butter Croissants',
  description: 'Flaky butter croissants. Perfect for breakfast.',
  brand: 'ParisianBakery',
  category: bakery
)

ProductVariant.create!([
                         { product: croissants, sku: 'CROISSANT-4PACK', price: 6.99, stock_quantity: 50,
                           variant_name: '4 Pack' },
                         { product: croissants, sku: 'CROISSANT-8PACK', price: 12.99, stock_quantity: 30,
                           variant_name: '8 Pack' }
                       ])

# Beverages
orange_juice = Product.create!(
  name: 'Fresh Orange Juice',
  description: 'Freshly squeezed orange juice. No added sugar.',
  brand: 'PureJuice',
  category: beverages
)

ProductVariant.create!([
                         { product: orange_juice, sku: 'OJ-1L-001', price: 5.99, stock_quantity: 70,
                           variant_name: '1 Liter' },
                         { product: orange_juice, sku: 'OJ-2L-001', price: 10.99, stock_quantity: 40,
                           variant_name: '2 Liters' }
                       ])

# Snacks
chips = Product.create!(
  name: 'Potato Chips',
  description: 'Crispy potato chips. Lightly salted.',
  brand: 'CrunchySnacks',
  category: snacks
)

ProductVariant.create!([
                         { product: chips, sku: 'CHIPS-150G-001', price: 2.99, stock_quantity: 120,
                           variant_name: '150g' },
                         { product: chips, sku: 'CHIPS-300G-001', price: 5.49, stock_quantity: 80,
                           variant_name: '300g' }
                       ])

# Create delivery slots
puts 'Creating delivery slots...'
7.times do |i|
  day = Date.today + i.days

  # Morning slot
  morning_start = day.beginning_of_day + 9.hours
  DeliverySlot.create!(
    start_time: morning_start,
    end_time: morning_start + 2.hours,
    is_available: true
  )

  # Afternoon slot
  afternoon_start = day.beginning_of_day + 14.hours
  DeliverySlot.create!(
    start_time: afternoon_start,
    end_time: afternoon_start + 2.hours,
    is_available: true
  )

  # Evening slot
  evening_start = day.beginning_of_day + 18.hours
  DeliverySlot.create!(
    start_time: evening_start,
    end_time: evening_start + 2.hours,
    is_available: true
  )
end

# Create addresses for customer
puts 'Creating customer addresses...'
Address.create!([
                  {
                    user: customer,
                    street: '123 Main Street',
                    city: 'New York',
                    state: 'NY',
                    zip_code: '10001',
                    country: 'USA'
                  },
                  {
                    user: customer,
                    street: '456 Park Avenue',
                    city: 'New York',
                    state: 'NY',
                    zip_code: '10022',
                    country: 'USA'
                  }
                ])

# Create a sample cart for customer
puts 'Creating sample cart...'
cart = Cart.create!(user: customer)
CartItem.create!(cart:, product_variant: milk.product_variants.first, quantity: 2)
CartItem.create!(cart:, product_variant: apples.product_variants.first, quantity: 1)
CartItem.create!(cart:, product_variant: bread.product_variants.first, quantity: 1)

# Create sample orders
puts 'Creating sample orders...'
address = customer.addresses.first
slot = DeliverySlot.first

order = Order.create!(
  user: customer,
  address:,
  delivery_slot: slot,
  total_price: 25.47,
  status: :delivered,
  payment_status: :paid
)

OrderItem.create!([
                    { order:, product_variant: milk.product_variants.first, quantity: 2, price_at_purchase: 3.99 },
                    { order:, product_variant: apples.product_variants.first, quantity: 1, price_at_purchase: 2.99 },
                    { order:, product_variant: bread.product_variants.first, quantity: 3, price_at_purchase: 2.99 },
                    { order:, product_variant: bananas.product_variants.first, quantity: 2, price_at_purchase: 1.99 }
                  ])

puts "\n" + '=' * 50
puts 'Seed data created successfully!'
puts '=' * 50
puts "\nCredentials:"
puts '  Admin:    admin@freshgrocer.com / password123'
puts '  Customer: customer@example.com / password123'
puts "\nStatistics:"
puts "  Categories: #{Category.count}"
puts "  Products: #{Product.count}"
puts "  Product Variants: #{ProductVariant.count}"
puts "  Delivery Slots: #{DeliverySlot.count}"
puts "  Addresses: #{Address.count}"
puts "  Sample Orders: #{Order.count}"
puts "\nAccess the application:"
puts '  Customer Storefront: http://localhost:3000'
puts '  Admin Dashboard: http://localhost:3000/admin'
puts '=' * 50
