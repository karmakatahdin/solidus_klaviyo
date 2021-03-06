# frozen_string_literal: true

module SolidusKlaviyo
  class SubscribeJob < ApplicationJob
    queue_as :default

    def perform(list_id, email, properties = {})
      SolidusKlaviyo::Subscriber.new(list_id).subscribe(email, properties)
    end
  end
end
