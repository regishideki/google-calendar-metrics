module Boundaries
  module Infra
    module Adapters
      class Event
        extend Forwardable

        def_delegators :@provider_event, :start, :end, :summary

        def initialize(provider_event)
          @provider_event = provider_event
        end

        def refining?
          !!(provider_event.summary =~ /refining/i)
        end

        def duration
          return 0 if provider_event.end.date_time.nil?

          (provider_event.end.date_time - provider_event.start.date_time).to_f * 24
        end

        private

        attr_reader :provider_event
      end
    end
  end
end
