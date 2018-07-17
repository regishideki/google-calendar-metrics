require './boundaries/infra/authorization'

module Boundaries
  module Infra
    module Services
      class GoogleCalendar
        APPLICATION_NAME = 'Google Calendar'.freeze

        def initialize(overrides = {})
          @google_service = overrides.fetch(:google_service) { Google::Apis::CalendarV3::CalendarService.new }
          @google_service.client_options.application_name = APPLICATION_NAME
          @google_service.authorization = Boundaries::Infra::Authorization.new.credentials
        end

        def list_events(calendar_id, parameters = {})
          google_service.list_events(calendar_id, parameters)
        end

        private

        attr_reader :google_service
      end
    end
  end
end
