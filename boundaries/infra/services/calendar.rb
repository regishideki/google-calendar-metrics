require './boundaries/infra/authorization'

module Boundaries
  module Infra
    module Services
      class Calendar
        APPLICATION_NAME = 'Google Calendar'.freeze

        def initialize(overrides = {})
          @provider_service = overrides.fetch(:provider_service) { Google::Apis::CalendarV3::CalendarService.new }
          @provider_service.client_options.application_name = APPLICATION_NAME
          @provider_service.authorization = Boundaries::Infra::Authorization.new.credentials
        end

        def list_events(calendar_id, parameters = {})
          provider_service.list_events(calendar_id, parameters)
        end

        private

        attr_reader :provider_service
      end
    end
  end
end
