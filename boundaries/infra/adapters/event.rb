module Boundaries
  module Infra
    module Adapters
      class Event
        extend Forwardable

        def_delegators :@event, :start, :end, :summary

        def initialize(google_api_event)
          @event = google_api_event
        end

        def refining?
          !!(event.summary =~ /refining/i)
        end

        private

        attr_reader :event
      end
    end
  end
end
