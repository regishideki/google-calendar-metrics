require './boundaries/infra/adapters/event'
require './boundaries/infra/services/google_calendar'

module Boundaries
  module Infra
    class Gateway
      def initialize
        @event_adapter_class = Boundaries::Infra::Adapters::Event
        @service = Boundaries::Infra::Services::GoogleCalendar.new
      end

      def list_events(parameters = {})
        response = service.list_events(
          parameters.fetch(:calendar_id, 'primary'),
          max_results: parameters.fetch(:max_results, 10),
          single_events: parameters.fetch(:single_events, true),
          order_by: parameters.fetch(:order_by, 'startTime'),
          time_min: parameters.fetch(:time_min, Time.now.iso8601)
        )

        build_response(response)
      end

      private

      attr_reader :service, :event_adapter_class

      def build_response(response)
        response.items.map(&method(:build_event))
      end

      def build_event(google_api_event)
        event_adapter_class.new(google_api_event)
      end
    end
  end
end
