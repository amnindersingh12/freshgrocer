# 🛒 FreshGrocer - Modern Grocery E-Commerce Platform

A complete, production-ready grocery e-commerce application built with **Ruby on Rails 7**, **Tailwind CSS**, and **Hotwire** (Turbo + Stimulus).

![Ruby on Rails](https://img.shields.io/badge/Rails-7.1.3-red?logo=ruby-on-rails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue?logo=postgresql)
![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-2.0-38bdf8?logo=tailwind-css)
![Hotwire](https://img.shields.io/badge/Hotwire-Turbo+Stimulus-orange)

---

## ✨ Features

### 🛍️ Customer Features

- **Product Browsing**: Search, filter by category, and view product details
- **Shopping Cart**: Real-time cart updates with Turbo Streams
- **Guest Shopping**: Add items without account (cart merges on login)
- **User Authentication**: Sign up, sign in, password recovery via Devise
- **Profile Management**: Update personal details, manage addresses
- **Order Management**: Place orders, view history, track status
- **Multi-Step Checkout**: Address selection → Payment → Confirmation
- **Responsive Design**: Mobile-first UI with Tailwind CSS

### 🎛️ Admin Panel

- **Dashboard Analytics**: Sales metrics, order stats, top products
- **Product Management**: CRUD operations with soft deletes
- **Product Variants**: Manage SKU, price, stock quantity per variant
- **Order Management**: Update order status and payment status
- **Category Management**: Hierarchical category structure
- **User Management**: View customers, change roles (admin/customer)

### 🚀 Technical Highlights

- **Authentication**: Devise with role-based authorization
- **State Machines**: AASM for order workflows
- **Real-Time Updates**: Hotwire Turbo Streams for dynamic UI
- **Soft Deletes**: Keep historical data with Discard gem
- **Pagination**: Kaminari for efficient data browsing
- **SEO-Friendly URLs**: Friendly slugs for products
- **CSRF Protection**: Configured for GitHub Codespaces

---

## 📋 Prerequisites

- **Ruby**: 3.3.0
- **Rails**: 7.1.3
- **Database**: PostgreSQL
- **Node.js**: For asset pipeline
- **Redis**: (Optional) For background jobs

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd codespaces-rails
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Setup Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Start the Server

```bash
bin/dev
```

Visit: `http://localhost:3000`

---

## 👤 Default Users

### Admin Account

- **Email**: `admin@freshgrocer.com`
- **Password**: `password`
- **Access**: Full admin dashboard

### Customer Account

- **Email**: `customer@example.com`
- **Password**: `password`
- **Access**: Customer storefront

---

## 🗂️ Project Structure

```
app/
├── controllers/
│   ├── admin/              # Admin namespace
│   ├── account/            # Customer account management
│   ├── carts_controller.rb # Shopping cart logic
│   └── orders_controller.rb # Order processing
├── models/
│   ├── user.rb             # Devise authentication
│   ├── product.rb          # Products with soft deletes
│   ├── product_variant.rb  # Product variants
│   ├── cart.rb             # Session/User carts
│   ├── order.rb            # Orders with AASM
│   └── category.rb         # Product categories
├── views/
│   ├── layouts/            # Application & admin layouts
│   ├── products/           # Product browsing
│   ├── carts/              # Shopping cart
│   ├── orders/             # Checkout & order details
│   ├── account/            # User profile & orders
│   └── admin/              # Admin dashboard
└── javascript/
    └── controllers/        # Stimulus controllers
```

---

## 🔑 Key Functionalities

### Shopping Cart

- **Guest Cart**: Session-based cart for non-logged-in users
- **User Cart**: Database-persisted cart for logged-in users
- **Cart Merge**: Guest cart merges with user cart on login
- **Real-Time Updates**: Turbo Streams update cart badge & modal instantly

### Checkout Process

1. **Cart Review**: View items, update quantities
2. **Address**: Select or add shipping address
3. **Payment**: Enter payment details (placeholder)
4. **Confirmation**: Order summary and success message

### Order Management

- **Customer View**: Track order status, view history
- **Admin View**: Update order status (pending → processing → shipped → delivered)
- **State Machine**: AASM ensures valid status transitions

### Product Variants

- Multiple variants per product (e.g., 500g, 1kg, 2kg)
- Individual pricing and stock per variant
- Dynamic price updates on variant selection

---

## 🛠️ Technologies Used

### Backend

- **Ruby on Rails 7.1.3**: Web framework
- **PostgreSQL**: Primary database
- **Devise 4.9**: User authentication
- **AASM**: State machine for orders
- **Discard**: Soft deletes for products
- **Kaminari**: Pagination

### Frontend

- **Hotwire (Turbo + Stimulus)**: Real-time interactivity
- **Tailwind CSS 2.0**: Utility-first styling
- **ImportMap**: JavaScript without bundlers
- **ERB**: Server-side templating

### Development

- **Foreman**: Process manager (`bin/dev`)
- **Hotwire Livereload**: Auto-refresh in development
- **Better Errors**: Enhanced error pages

---

## 📱 Responsive Design

- **Mobile-First**: Optimized for phones and tablets
- **Breakpoints**: `sm`, `md`, `lg`, `xl` (Tailwind)
- **Touch-Friendly**: Large tap targets, gesture support
- **Hamburger Menu**: Collapsible navigation on mobile

---

## 🔒 Security

- **CSRF Protection**: Configured for Codespaces environment
- **Role-Based Access**: Admin vs Customer permissions
- **Devise Security**: Password encryption, session management
- **SQL Injection Protection**: ActiveRecord parameterized queries

---

## 🐛 Known Issues & Fixes

All major issues have been resolved:

- ✅ Variant column naming (`variant_name` vs `variant_type`)
- ✅ CSRF token issues in Codespaces
- ✅ Turbo Frame "content missing" errors
- ✅ Cart icon real-time updates
- ✅ Flash message positioning
- ✅ Admin user role updates
- ✅ Remove item functionality

---

## 📦 Database Schema

### Core Models

- **Users**: Authentication, roles (admin/customer)
- **Products**: Name, description, brand, category, soft deletes
- **ProductVariants**: SKU, price, stock, variant name
- **Categories**: Hierarchical structure
- **Carts**: Session or user-based
- **CartItems**: Product variants + quantities
- **Orders**: Total price, status, payment status
- **OrderItems**: Snapshot of purchased items
- **Addresses**: User shipping addresses

---

## 🚧 Future Enhancements

- [ ] Payment gateway integration (Stripe/PayPal)
- [ ] Email notifications (order confirmation, shipping updates)
- [ ] Product reviews and ratings
- [ ] Inventory alerts for low stock
- [ ] Discount codes and promotions
- [ ] Advanced search with filters
- [ ] Wishlist functionality
- [ ] Multi-vendor support

---

## 📄 License

This project is open-source and available under the MIT License.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📞 Support

For issues or questions:

- Open an issue on GitHub
- Check existing documentation
- Review closed issues for solutions

---

**Built with ❤️ using Ruby on Rails**
