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
          'to status records that were last reported before or on the given date.')
        def system_status
          accepted = [:system_id, :organization_id, :status, :on_date]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a "consumer"
          system_to_consumer(report_params)

          # gutterball wants an "owner"
          organization_to_owner(report_params)

          resp = service.run_reports('consumer_status', report_params)
          resp = SystemStatusResponse.new(resp).entries
          render :json => resp
        end

        api :GET, '/content_reports/system_trend', N_('Show a listing of all subscription status snapshots from ' \
          'content hosts which have reported their subscription status in the specified time period.')
        param :system_id, :identifier, :desc => N_('Filters the results by the given content host UUID.')
        param :organization_id, :identifier, :desc => N_('Organization ID'), :required => true
        param :start_date, Date, :desc => N_('Start date. Used in conjuction with end_date.')
        param :end_date, Date, :desc => N_('End date. Used in conjection with start_date.')
        param :hours, Integer,
          :desc => N_('Show a trend between HOURS and now. Used independently of start_date/end_date.')
        def system_trend
          accepted = [:system_id, :hours, :start_date, :end_date]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants a "consumer"
          system_to_consumer(report_params)

          # gutterball wants an "owner"
          organization_to_owner(report_params)

          render :json => service.run_reports('consumer_trend', report_params)
        end

        api :GET, '/content_reports/status_trend', N_('Show the per-day counts of content-hosts, grouped by ' \
          'subscription status, optionally limited to a date range.')
        param :organization_id, :identifier, :desc => N_('Organization ID'), :required => true
        param :start_date, Date, :desc => N_('Start date')
        param :end_date, Date, :desc => N_('End date')
        # TODO: enable the following params at some point
        # param :sku, String, :desc => N_('The entitlement SKU on which to filter'), :required => false
        # param :subscription_name, String, :desc => N_('The name of a subscription'), :required => false
        # param :management_enabled, String, :desc => N_('management_enabled')
        # param :timezone, String, :desc => N_('timezone')
        def status_trend
          accepted = [:organization_id,
                      :start_date,
                      :end_date]
          params.permit(*accepted)
          report_params = params.slice(*accepted)

          # gutterball wants an "owner"
          organization_to_owner(report_params)

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

        def organization_to_owner(report_params)
          # report_params[:owner] = @organization.label
          #
          report_params[:owner] = 'redhat' # temporarily to test against another server
          report_params.delete(:organization_id)
        end

        class SystemStatusResponse
          attr_reader :entries
          def initialize(data)
            @entries = []
            data.each do |dat|
              dat['system'] = dat.delete('consumer')
              dat['system']['system_state'] = dat['system'].delete('consumerState')
              dat['system']['organization'] = dat['system'].delete('owner')
              dat['system']['organization']['name'] = dat['system']['organization'].delete('displayName')
              dat['system']['organization']['label'] = dat['system']['organization'].delete('key')
              dat['system']['last_checkin'] = dat['system'].delete('lastCheckin')
              @entries << dat
            end
          end
        end

        class SystemTrendResponse
          def initialize(data)
            # stuf
          end

          def response
            # stuff
          end
        end

        class StatusTrendResponse
          def initialize(data)
            # stuff
          end

          def response
            # more stuff
          end
        end
      end
    end
  end
end
