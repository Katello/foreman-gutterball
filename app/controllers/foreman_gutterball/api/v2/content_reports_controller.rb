module ForemanGutterball
  module Api
    module V2
      class ContentReportsController < ::Katello::Api::V2::ApiController
        api :GET, '/content_reports', 'List available reports'
        def index
          render :json => service.report_details
        end

        api :GET, '/content_reports/:id', 'Report details'
        def show
          report = service.report_details params[:id]
          render :json => report
        end

        api :GET, '/content_reports/:id/run', 'Generate reports'
        def run
          query_params = request.query_parameters.symbolize_keys
          validate_params(query_params.keys) unless query_params.empty?
          report = service.run_reports(params[:id], query_params)
          render :json => report
        end

        private

        def consumer_status
          [:consumer_uuid, :owner, :status, :on_date, :page, :per_page, :custom]
        end

        def consumer_trend
          [:consumer_uuid, :hours, :start_date, :end_date, :custom]
        end

        def status_trend
          [:start_date, :end_date, :owner, :sku, :subscription_name, :management_enabled, :timezone]
        end

        def service
          GutterballService.new
        end

        def validate_params(query_keys)
          report_keys = send(params[:id])
          fail Katello::HttpErrors::BadRequest, _('Invalid parameters') unless report_keys & query_keys == query_keys
        end
      end
    end
  end
end
