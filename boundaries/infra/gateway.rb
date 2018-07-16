require './boundaries/infra/adapters/event'

module Boundaries
  module Infra
    class Gateway
      def initialize(service)
        @service = service
      end

      def list_events(calendar_id: 'primary', max_results: 10, single_events: true, order_by: 'startTime',
                      time_min: Time.now.iso8601)
        response = service.list_events(
          calendar_id, max_results: max_results, single_events: single_events, order_by: order_by, time_min: time_min
        )

        response.items.map do |google_api_event|
          Boundaries::Infra::Adapters::Event.new(google_api_event)
        end
      end

      private

      attr_reader :service
    end
  end
end
