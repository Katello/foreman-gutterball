module ForemanGutterball
  module Api
    module V2
      class ContentReportsController < ::Katello::Api::V2::ApiController
        api :GET, '/content_reports', 'List available reports'
        def index
          service.available_reports
        end

        api :GET, '/content_reports/consumer_status', 'Consumer status reports'
        def consumer_status
          service.consumer_status
        end

        api :GET, '/content_reports/consumer_trend', 'Consumer trend reports'
        def consumer_trend
          service.consumer_trend
        end

        api :GET, '/content_reports/status_trend', 'Status trend reports'
        def status_trend
          service.status_trend
        end

        private

        def service
          GutterballService.new
        end
      end
    end
  end
end
