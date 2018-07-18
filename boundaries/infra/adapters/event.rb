module Boundaries
  module Infra
    module Adapters
      class Event
        extend Forwardable

        def_delegators :@event, :start, :end, :summary

        def initialize(google_event)
          @event = google_event
        end

        def refining?
          !!(event.summary =~ /refining/i)
        end

        def duration
          return 0 if event.end.date_time.nil?

          (event.end.date_time - event.start.date_time).to_f * 24
        end

        private

        attr_reader :event
      end
    end
  end
end
