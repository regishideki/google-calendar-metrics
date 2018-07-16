require './boundaries/infra/adapters/event'
require './boundaries/infra/authorization'

module Boundaries
  module Infra
    class Gateway
      APPLICATION_NAME = 'Google Calendar'.freeze

      def initialize
        @event_adapter_class = Boundaries::Infra::Adapters::Event
        @service = Google::Apis::CalendarV3::CalendarService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = Boundaries::Infra::Authorization.new.authorize(service)
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

      def build_response(response)
        response.items.map(&method(:build_event))
      end

      def build_event(google_api_event)
        event_adapter_class.new(google_api_event)
      end

      attr_reader :service, :event_adapter_class
    end
  end
end
