# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Event::CancelledOrder do
  describe '#name' do
    it 'returns the name of the event' do
      order = build_stubbed(:order)

      event = described_class.new(order: order)

      expect(event.name).to eq('Cancelled Order')
    end
  end

  describe '#email' do
    it 'returns the email on the order' do
      order = build_stubbed(:order)

      event = described_class.new(order: order)

      expect(event.email).to eq(order.email)
    end
  end

  describe '#customer_properties' do
    it 'returns the serialized customer information' do
      order = build_stubbed(:order)
      allow(SolidusKlaviyo::Serializer::CustomerProperties).to receive(:serialize)
        .with(order.user)
        .and_return('$email' => 'jdoe@example.com')

      event = described_class.new(order: order)

      expect(event.customer_properties).to eq(
        '$email' => 'jdoe@example.com',
      )
    end
  end

  describe '#properties' do
    it 'includes the serialized order information' do
      order = build_stubbed(:order)
      allow(SolidusKlaviyo::Serializer::Order).to receive(:serialize)
        .with(order)
        .and_return('foo' => 'bar')

      event = described_class.new(order: order)

      expect(event.properties).to include('foo' => 'bar')
    end

    it 'includes an event ID and value' do
      order = build_stubbed(:order)
      allow(SolidusKlaviyo::Serializer::LineItem).to receive(:serialize)
        .with(order)
        .and_return('foo' => 'bar')

      event = described_class.new(order: order)

      expect(event.properties).to include(
        '$event_id' => order.id.to_s,
        '$value' => order.total,
      )
    end
  end

  describe '#time' do
    it "returns the order's cancellation time" do
      order = build_stubbed(:order, canceled_at: Time.zone.now)

      event = described_class.new(order: order)

      expect(event.time).to eq(order.canceled_at)
    end
  end
end
