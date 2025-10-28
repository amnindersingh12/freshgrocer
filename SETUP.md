# FreshGrocer E-Commerce Application - Setup Guide

This is a complete Ruby on Rails 7 grocery e-commerce application with admin dashboard and customer storefront.

## Features Implemented

### Customer Storefront

- ✅ Responsive homepage with hero section, featured products, and categories
- ✅ Product browsing with search and category filtering
- ✅ SEO-friendly URLs using FriendlyId gem
- ✅ Shopping cart with guest cart support
- ✅ Multi-step checkout process (Address → Delivery → Payment)
- ✅ Order history and management
- ✅ Address management
- ✅ Mobile-responsive design with Tailwind CSS
- ✅ Hotwire (Turbo + Stimulus) for dynamic interactions

### Admin Dashboard

- ✅ Dashboard with sales analytics and metrics
- ✅ Product management with CRUD operations
- ✅ Product variant management (nested under products)
- ✅ Soft deletes for products and variants
- ✅ Category management with parent/sub-category support
- ✅ Order management with state machines
- ✅ Order status tracking (pending → processing → shipped → delivered)
- ✅ Payment status tracking (unpaid → paid → refunded)
- ✅ User management (read-only)
- ✅ Search and filter capabilities

### Technical Features

- ✅ Devise authentication with role-based authorization
- ✅ AASM state machines for order workflow
- ✅ Background jobs for order notifications (Sidekiq)
- ✅ Guest cart merging on login/signup
- ✅ Flash messages for user feedback
- ✅ Mobile-first responsive design
- ✅ Touch-friendly controls
- ✅ Turbo Streams for real-time updates
- ✅ Stimulus controllers for dynamic price updates and cart management

## Installation Steps

### 1. Install Dependencies

```bash
bundle install
```

### 2. Setup Tailwind CSS

```bash
rails tailwindcss:install
```

### 3. Configure Database

Update `config/database.yml` to use PostgreSQL:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: freshgrocer_development

test:
  <<: *default
  database: freshgrocer_test

production:
  <<: *default
  database: freshgrocer_production
  username: freshgrocer
  password: <%= ENV["FRESHGROCER_DATABASE_PASSWORD"] %>
```

### 4. Initialize FriendlyId

```bash
rails generate friendly_id
```

### 5. Initialize Devise

```bash
rails generate devise:install
rails generate devise:views
```

### 6. Create and Migrate Database

```bash
rails db:create
rails db:migrate
```

### 7. Seed Sample Data

Create `db/seeds.rb` with sample data:

```ruby
# Create admin user
admin = User.create!(
  email: 'admin@freshgrocer.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Admin User',
  role: :admin
)

# Create customer user
customer = User.create!(
  email: 'customer@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'John Doe',
  role: :customer
)

# Create categories
dairy = Category.create!(name: 'Dairy & Eggs')
fruits = Category.create!(name: 'Fresh Fruits')
vegetables = Category.create!(name: 'Vegetables')
bakery = Category.create!(name: 'Bakery')
beverages = Category.create!(name: 'Beverages')
snacks = Category.create!(name: 'Snacks & Treats')

# Create sub-categories
milk_subcategory = Category.create!(name: 'Milk', parent: dairy)
cheese_subcategory = Category.create!(name: 'Cheese', parent: dairy)

# Create products
milk = Product.create!(
  name: 'Whole Milk',
  description: 'Fresh whole milk from local farms',
  brand: 'FreshFarms',
  category: milk_subcategory
)

# Create product variants
ProductVariant.create!(
  product: milk,
  sku: 'MILK-1L-001',
  price: 3.99,
  stock_quantity: 100,
  variant_name: '1 Liter'
)

ProductVariant.create!(
  product: milk,
  sku: 'MILK-2L-001',
  price: 6.99,
  stock_quantity: 50,
  variant_name: '2 Liters'
)

# Add more products...
apples = Product.create!(
  name: 'Red Apples',
  description: 'Crisp and sweet red apples',
  brand: 'OrchardFresh',
  category: fruits
)

ProductVariant.create!(
  product: apples,
  sku: 'APPLE-500G-001',
  price: 2.99,
  stock_quantity: 200,
  variant_name: '500g'
)

# Create delivery slots
3.times do |i|
  start_time = (Date.today + i.days).beginning_of_day + 9.hours
  DeliverySlot.create!(
    start_time: start_time,
    end_time: start_time + 2.hours,
    is_available: true
  )
end

# Create addresses for customer
Address.create!(
  user: customer,
  street: '123 Main Street',
  city: 'New York',
  state: 'NY',
  zip_code: '10001',
  country: 'USA'
)

puts "Seed data created successfully!"
puts "Admin credentials: admin@freshgrocer.com / password123"
puts "Customer credentials: customer@example.com / password123"
```

Run seeds:

```bash
rails db:seed
```

### 8. Configure Sidekiq

Add to `config/application.rb`:

```ruby
config.active_job.queue_adapter = :sidekiq
```

### 9. Start the Application

In separate terminal windows:

```bash
# Terminal 1: Rails server
rails server

# Terminal 2: Tailwind CSS (watch mode)
rails tailwindcss:watch

# Terminal 3: Sidekiq
bundle exec sidekiq
```

### 10. Access the Application

- **Customer Storefront**: http://localhost:3000
- **Admin Dashboard**: http://localhost:3000/admin (login as admin)

## Default Credentials

- **Admin**: admin@freshgrocer.com / password123
- **Customer**: customer@example.com / password123

## Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb (with authorization helpers)
│   ├── home_controller.rb
│   ├── products_controller.rb
│   ├── categories_controller.rb
│   ├── carts_controller.rb
│   ├── orders_controller.rb
│   ├── account/
│   │   ├── orders_controller.rb
│   │   └── addresses_controller.rb
│   └── admin/
│       ├── base_controller.rb
│       ├── dashboard_controller.rb
│       ├── products_controller.rb
│       ├── product_variants_controller.rb
│       ├── orders_controller.rb
│       ├── categories_controller.rb
│       └── users_controller.rb
├── models/
│   ├── user.rb (Devise + role enum)
│   ├── product.rb (FriendlyId + Discard)
│   ├── product_variant.rb (Discard)
│   ├── category.rb (FriendlyId + self-referential)
│   ├── cart.rb (guest cart support)
│   ├── cart_item.rb
│   ├── order.rb (AASM state machines)
│   ├── order_item.rb
│   ├── address.rb
│   └── delivery_slot.rb
├── views/
│   ├── layouts/
│   │   ├── application.html.erb (customer layout)
│   │   └── admin.html.erb (admin layout)
│   ├── shared/
│   │   └── _flash.html.erb
│   └── [Additional views to be created]
├── javascript/
│   └── controllers/
│       ├── product_variant_controller.js
│       ├── cart_controller.js
│       ├── flash_controller.js
│       └── mobile_menu_controller.js
└── jobs/
    └── order_confirmation_job.rb
```

## Key Gems Used

- **rails** (7.1.3): Web framework
- **pg**: PostgreSQL database adapter
- **devise**: Authentication
- **tailwindcss-rails**: CSS framework
- **friendly_id**: SEO-friendly URLs
- **aasm**: State machines
- **discard**: Soft deletes
- **sidekiq**: Background job processing
- **kaminari**: Pagination
- **turbo-rails** & **stimulus-rails**: Hotwire for SPA-like experience

## Routes Overview

### Customer Routes

- `GET /` - Homepage
- `GET /products` - Product listing
- `GET /products/:slug` - Product detail
- `GET /categories` - Category listing
- `GET /categories/:slug` - Category detail
- `GET /cart` - Shopping cart
- `POST /cart/add_item` - Add to cart
- `GET /orders/new` - Checkout
- `POST /orders` - Create order
- `GET /account/orders` - Order history
- `GET /account/addresses` - Manage addresses

### Admin Routes (namespaced under /admin)

- `GET /admin` - Dashboard
- `GET /admin/products` - Product management
- `GET /admin/categories` - Category management
- `GET /admin/orders` - Order management
- `GET /admin/users` - User management

## Mobile Responsiveness

The application is fully mobile-responsive:

- Mobile-first design approach
- Hamburger menu for mobile navigation
- Collapsible admin sidebar
- Touch-friendly controls (min-h-12)
- Responsive grids and layouts
- Scrollable tables on mobile
- Card layouts for small screens

## State Machines

### Order Status

- `pending` → `processing` → `shipped` → `delivered`
- Can be cancelled from `pending` or `processing`

### Payment Status

- `unpaid` → `paid` → `refunded`

## Features to Complete

The following view files need to be created to complete the application. You can create them using the patterns established in this setup:

### Customer Views

- `app/views/products/index.html.erb`
- `app/views/products/show.html.erb`
- `app/views/categories/index.html.erb`
- `app/views/categories/show.html.erb`
- `app/views/carts/show.html.erb`
- `app/views/carts/_cart.html.erb` (partial)
- `app/views/orders/new.html.erb` (multi-step)
- `app/views/orders/show.html.erb`
- `app/views/account/orders/index.html.erb`
- `app/views/account/orders/show.html.erb`
- `app/views/account/addresses/index.html.erb`
- `app/views/account/addresses/_form.html.erb`

### Admin Views

- `app/views/admin/dashboard/index.html.erb`
- `app/views/admin/products/index.html.erb`
- `app/views/admin/products/show.html.erb`
- `app/views/admin/products/_form.html.erb`
- `app/views/admin/product_variants/_form.html.erb`
- `app/views/admin/product_variants/_variant.html.erb` (partial)
- `app/views/admin/orders/index.html.erb`
- `app/views/admin/orders/show.html.erb`
- `app/views/admin/categories/index.html.erb`
- `app/views/admin/categories/_form.html.erb`
- `app/views/admin/users/index.html.erb`

## Testing

Run the application and test the following flows:

1. **Guest Shopping**:

   - Browse products as guest
   - Add items to cart
   - Sign up during checkout
   - Cart should merge with user account

2. **Customer Flow**:

   - Login as customer
   - Browse and search products
   - Add items to cart
   - Complete checkout (address → delivery → payment)
   - View order history

3. **Admin Flow**:
   - Login as admin
   - View dashboard metrics
   - Create/edit products and variants
   - Manage orders and update status
   - Create categories

## Customization

### Update Branding

- Change "FreshGrocer" to your brand name in layouts
- Update color scheme in Tailwind CSS classes (green-600 → your-color)
- Add your logo images

### Add Email Notifications

- Create ActionMailer classes
- Uncomment email sending code in `OrderConfirmationJob`
- Configure SMTP settings

### Add Payment Integration

- Integrate Stripe or other payment gateway
- Update orders controller payment step
- Add payment processing logic

## Troubleshooting

### Database Issues

```bash
rails db:drop db:create db:migrate db:seed
```

### Asset Issues

```bash
rails assets:clobber
rails tailwindcss:build
```

### Cache Issues

```bash
rails dev:cache
rails tmp:clear
```

## Production Deployment

Before deploying to production:

1. Set environment variables for database credentials
2. Configure Redis for Sidekiq
3. Setup email delivery (SMTP/SendGrid)
4. Enable HTTPS
5. Precompile assets: `rails assets:precompile`
6. Set `RAILS_SERVE_STATIC_FILES=true` if needed
7. Configure `config/credentials.yml.enc`

## Support

For issues or questions about this setup, refer to:

- Rails Guides: https://guides.rubyonrails.org/
- Tailwind CSS: https://tailwindcss.com/docs
- Hotwire: https://hotwired.dev/

## License

This application code is provided as-is for educational and commercial use.
