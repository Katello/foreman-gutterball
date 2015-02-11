module ForemanGutterball
  class GutterballService < ::Katello::HttpResource
    def initialize
      cfg = SETTINGS.with_indifferent_access
      url = cfg['foreman_gutterball']['url']
      self.prefix = URI.parse(url).path
      self.site = url.gsub(prefix, '')
      self.consumer_secret = cfg[:oauth_consumer_secret]
      self.consumer_key = cfg[:oauth_consumer_key]
      self.ca_cert_file = cfg[:ca_cert_file]
    end

    def self.default_headers
      { 'accept' => 'application/json',
        'accept-language' => I18n.locale,
        'content-type' => 'application/json' }
    end

    def self.logger
      ::Logging.logger['gutterball_service']
    end

    def report_details(report_key)
      path = self.class.join_path(prefix, 'reports', report_key)
      JSON.parse self.class.get(path, default_headers)
    end

    def report(report_key, query_params)
      format_query(query_params)
      path = self.class.join_path(prefix, 'reports', report_key, 'run', self.class.hash_to_query(query_params))
      resp = JSON.parse self.class.get(path, default_headers)
      send("format_#{report_key}_response", resp) # REFLECTION!!!11!1
    end

    private

    def format_query(params)
      if params[:system_id]
        params[:consumer_uuid] = params.delete(:system_id)
      end

      # params[:owner] = Organization.find(params[:organization_id]).label
      params[:owner] = 'redhat' # temporarily to test against another server
      params.delete(:organization_id)

      params[:custom] = 1
    end

    def format_consumer_status_response(response)
      # do all your crazy shit here
      response
    end

    def format_consumer_trend_response(response)
      # crazy schtuff
      response
    end

    def format_status_trend_response(response)
      # moar crazy
      response
    end
  end
end
