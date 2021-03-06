# frozen_string_literal: true

module SolidusKlaviyo
  module Event
    class StartedCheckout < Base
      def name
        'Started Checkout'
      end

      delegate :email, to: :order

      def customer_properties
        Serializer::CustomerProperties.serialize(order.user || order.email)
      end

      def properties
        Serializer::Order.serialize(order).merge(
          '$event_id' => order.id.to_s,
          '$value' => order.total,
        )
      end

      def time
        order.updated_at
      end

      private

      def order
        payload.fetch(:order)
      end
    end
  end
end
