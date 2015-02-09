module ForemanGutterball
  module Api
    module V2
      class ContentReportsController < ::Katello::Api::V2::ApiController
        before_filter :find_organization, :only => [:system_status, :system_trend, :status_trend]

        api :GET, '/content_reports/system_status', N_('Show the latest subscription status for a list of content ' \
          'hosts that have reported their subscription status during a specified time period. Running this report ' \
          'with minimal parameters will return all status records for all reported content hosts.')
        param :system_id, :identifier, :desc => N_('Filters the results by the given content host UUID.')
        param :organization_id, :identifier, :desc => N_('Organization ID'), :required => true
        param :status, ['valid', 'invalid', 'partial'], :desc => N_('Filter results on content host status.')
        param :on_date, Date, :desc => N_('Date to filter on. If not given, defaults to NOW. Results will be limited ' \
          'to status records that where last reported before or on the given date.')
        def system_status
          accepted = [:system_id, :organization_id, :status, :on_date, :page, :per_page, :custom]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a "consumer"
          system_to_consumer(report_params)

          # gutterball wants an owner
          report_params[:owner] = @organization.label
          report_params.delete(:organization_id)

          render :json => service.run_reports('consumer_status', report_params)
        end

        api :GET, '/content_reports/system_trend', 'Generate a content host trend report'
        param :system_id, :identifier, :desc => N_('Content host UUID')
        param :organization_id, :identifier, :desc => N_('Organization ID'), :required => true
        param :start_date, Date, :desc => N_('Start date')
        param :end_date, Date, :desc => N_('End date')
        param :hours, Integer, :desc => N_('Show a trend between HOURS and now.')
        def system_trend
          accepted = [:system_id, :hours, :start_date, :end_date, :custom]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a "consumer"
          system_to_consumer(report_params)

          render :json => service.run_reports('consumer_trend', report_params)
        end

        api :GET, '/content_reports/status_trend', 'Generate a status trend report'
        param :organization_id, :identifier, :desc => N_('Organization ID'), :required => true
        param :start_date, Date, :desc => N_('Start date')
        param :end_date, Date, :desc => N_('End date')
        # param :sku, String, :desc => N_('The entitlement SKU on which to filter'), :required => false
        # param :subscription_name, String, :desc => N_('The name of a subscription'), :required => false
        # param :management_enabled, String, :desc => N_('management_enabled')
        # param :timezone, String, :desc => N_('timezone')
        def status_trend
          accepted = [:organization_id,
                      :start_date,
                      :end_date,
                      :sku,
                      :subscription_name,
                      :management_enabled,
                      :timezone]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants an "owner"
          report_params[:owner] = @organization.label
          report_params.delete(:organization_id)

          render :json => service.run_reports('status_trend', report_params)
        end

        private

        def service
          GutterballService.new
        end

        def system_to_consumer(report_params)
          if report_params[:system_id]
            report_params[:consumer_uuid] = report_params[:system_id]
            report_params.delete(:system_id)
          end
        end
      end
    end
  end
end
