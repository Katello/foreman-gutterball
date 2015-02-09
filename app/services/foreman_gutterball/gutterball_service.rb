require 'rest_client'

module ForemanGutterball
  class GutterballService < ::Katello::HttpResource
    cfg = SETTINGS.with_indifferent_access
    url = cfg['foreman_gutterball']['url']
    self.prefix = URI.parse(url).path
    self.site = url.gsub(prefix, '')
    self.consumer_secret = cfg[:oauth_consumer_secret]
    self.consumer_key = cfg[:oauth_consumer_key]
    self.ca_cert_file = cfg[:ca_cert_file]

    def self.default_headers
      { 'accept' => 'application/json',
        'accept-language' => I18n.locale,
        'content-type' => 'application/json' }
    end

    def self.logger
      ::Logging.logger['gutterball_service']
    end

    def report_details(report_key = nil)
      report_path = "#{prefix}reports/#{report_key}"
      get_reports(report_path, default_headers)
    end

    def run_reports(report_key, query_params = nil)
      report_path = "#{prefix}/reports/#{report_key}/run?#{query_params.to_query}"
      get_reports(report_path, default_headers)
    end

    private

    def get_reports(path, headers = {})
      self.class.get(path, headers)
    end
  end
end
