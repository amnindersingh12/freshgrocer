# frozen_string_literal: true

class OrderConfirmationJob < ApplicationJob
  queue_as :default

  def perform(order_id, event_type)
    order = Order.find(order_id)

    # In a real application, this would send an email
    # For now, we'll just log the event
    Rails.logger.info "Order ##{order.id} - #{event_type} event triggered"
    Rails.logger.info "Customer: #{order.user.email}"
    Rails.logger.info "Total: $#{order.total_price}"

    # Example: Send email using ActionMailer
    # OrderMailer.with(order: order).confirmation_email.deliver_later if event_type == 'created'
    # OrderMailer.with(order: order).shipped_email.deliver_later if event_type == 'shipped'
    # OrderMailer.with(order: order).delivered_email.deliver_later if event_type == 'delivered'
  end
end
