module ForemanGutterball
  class GutterballService < ::Katello::HttpResource
    def initialize
      cfg = SETTINGS.with_indifferent_access
      url = cfg['foreman_gutterball']['url']
      @uri = URI.parse(url)
      self.prefix = @uri.path
      self.site = "#{@uri.scheme}://#{@uri.host}:#{@uri.port}"
      self.class.site = site
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

    def hash_to_query(query_parameters)
      query_parameters.reduce('?') do |result, (current_key, current_value) |
        result << '&' unless result == '?'
        if current_value.is_a?(Array)
          result << current_value.map { |value| "#{current_key}=#{self.class.url_encode(value)}" }.join('&')
        else
          result << "#{current_key}=#{self.class.url_encode(current_value)}"
        end
      end
    end

    def report(report_key, query_params)
      format_query(query_params)
      path = self.class.join_path(prefix, 'reports', report_key, 'run')
      raw = get_with_params(path, default_headers, hash_to_query(query_params))
      resp = JSON.parse(raw)
      send("format_#{report_key}_response", resp)
    end

    private

    def format_query(params)
      if params[:system_id]
        params[:consumer_uuid] = params.delete(:system_id)
      end
      if params[:start_date]
        date_string = params[:start_date]
        date_string += ' 00:00:00' if date_string.length < 11 # beginning of day
        params[:start_date] = DateTime.parse(date_string).strftime('%Y-%m-%dT%H:%M:%S.%L%z')
      end
      %w(end_date on_date).each do |key|
        if params[key]
          date_string = params[key]
          date_string += ' 24:00:00' if date_string.length < 11 # end of day
          params[key] = DateTime.parse(date_string).strftime('%Y-%m-%dT%H:%M:%S.%L%z')
        end
      end
      params[:owner] = Organization.find(params[:organization_id]).label
      params.delete(:organization_id)
    end

    def format_consumer_status_response(response)
      response.map do |member|
        { :name => member['consumer']['name'],
          :status => member['status']['status'],
          :date => iso8601_to_yyyy_mm_dd(member['status']['date']) }
      end
    end

    def format_consumer_trend_response(response)
      response.map do |member|
        { :date => iso8601_to_yyyy_mm_dd_hms(member['status']['date']),
          :status => member['status']['status'] }
      end
    end

    def format_status_trend_response(response)
      template = { :valid => 0, :invalid => 0, :partial => 0 }
      response.reduce([]) do |resp, (datetime, values)|
        resp << template.merge(values).merge(:date => iso8601_to_yyyy_mm_dd(datetime))
        resp
      end
    end

    def iso8601_to_yyyy_mm_dd(datetime)
      DateTime.iso8601(datetime).strftime('%Y-%m-%d')
    end

    def iso8601_to_yyyy_mm_dd_hms(datetime)
      DateTime.iso8601(datetime).strftime('%Y-%m-%d %H:%M:%S')
    end

    def get_with_params(a_path, headers = {}, params = '')
      self.class.logger.debug "Resource GET request: #{a_path}"
      self.class.print_debug_info(a_path, headers)
      a_path = URI.encode(a_path)
      client = self.class.rest_client(Net::HTTP::Get, :get, a_path  + params)
      self.class.process_response(client.get(headers))
    rescue RestClient::Exception => e
      self.class.raise_rest_client_exception e, a_path, 'GET'
    rescue Errno::ECONNREFUSED
      service = a_path.split('/').second
      raise Errors::ConnectionRefusedException, _('A backend service [ %s ] is unreachable') % service.capitalize
    end
  end
end
