module ForemanGutterball
  module Api
    module V2
      class ContentReportsController < ::Katello::Api::V2::ApiController
        before_filter :find_organization, :only => [:system_status, :system_trend, :status_trend]

        api :GET, '/content_reports/system_status', 'Generate a content host status report'
        param :system_id, :identifier, :desc => N_('content host uuid')
        param :organization_id, :identifier, :desc => N_('organization id'), :required => true
        param :status, String, :desc => N_("status: i'm guessing this is an enumeration of a couple statusi?")
        param :on_date, Date, :desc => N_('Date to filter on.')
        # param :page, String, :desc => N_('page yo')
        # param :per_page, String, :desc => N_('per_page')
        # TODO: find out wtf 'custom' is
        # param :custom, String, :desc => N_('custom')
        def system_status
          accepted = [:system_id, :organization_id, :status, :on_date, :page, :per_page, :custom]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a consumer
          if report_params[:system_id]
            report_params[:consumer_uuid] = report_params[:system_id]
            report_params.delete(:system_id)
          end

          # gutterball wants an owner
          report_params[:owner] = @organization.label
          report_params.delete(:organization_id)

          render :json => service.run_reports('consumer_status', report_params)
        end

        api :GET, '/content_reports/system_trend', 'Generate a content host trend report'
        param :system_id, :identifier, :desc => N_('content host uuid')
        param :organization_id, :identifier, :desc => N_('organization id'), :required => true
        param :start_date, Date, :desc => N_('Start date')
        param :end_date, Date, :desc => N_('End date')
        # param :hours, String, :desc => N_('hours')
        # TODO: find out wtf 'custom' is
        # param :custom, String, :desc => N_('custom')
        def system_trend
          accepted = [:system_id, :hours, :start_date, :end_date, :custom]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a consumer
          if report_params[:system_id]
            report_params[:consumer_uuid] = report_params[:system_id]
            report_params.delete(:system_id)
          end

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

          # gutterball wants an owner
          report_params[:owner] = @organization.label
          report_params.delete(:organization_id)

          render :json => service.run_reports('status_trend', report_params)
        end

        private

        def service
          GutterballService.new
        end
      end
    end
  end
end
