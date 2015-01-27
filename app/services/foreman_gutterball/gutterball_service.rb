require 'rest_client'

module ForemanGutterball
  class GutterballResource < ::Katello::HttpResource
    cfg = SETTINGS.with_indifferent_access
    url = cfg[:url]
    self.prefix = 'gutterball/reports'
    self.site = url.gsub(prefix, '')
    self.consumer_secret = cfg[:oauth_consumer_secret]
    self.consumer_key = cfg[:oauth_consumer_key]
    self.ca_cert_file = cfg[:ca_cert_file]

    def self.logger
      ::Logging.logger['gutterball_service']
    end

    def self.default_headers
      { 'accept' => 'application/json',
        'accept-language' => I18n.locale,
        'content-type' => 'application/json' }
    end
  end

  class GutterballService < GutterballResource
    # rubocop:disable Style/CyclomaticComplexity
    def initialize(_options = {})
    end

    def available_reports
      get_reports(report_path, default_headers)
    end

    def consumer_status(params = nil)
      get_reports(report_path('/consumer_status', params), default_headers)
    end

    def consumer_trend(params = nil)
      get_reports(report_path('/consumer_trend', params), default_headers)
    end

    def status_trend(params = nil)
      get_reports(report_path('/status_trend', params), default_headers)
    end

    def report_path(report_key = nil, params = nil)
      "#{prefix}#{report_key}#{params}"
    end

    private

    def get_reports(path, headers = {})
      client = GutterballResource.rest_client(Net::HTTP::Get, :get, path)
      JSON.parse client.get(headers)
    end
  end
end
