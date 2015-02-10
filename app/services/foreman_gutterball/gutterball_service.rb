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

    def run_reports(report_key, query_params = nil)
      report_path = self.class.join_path(prefix, 'reports', report_key, 'run', self.class.hash_to_query(query_params))
      JSON.parse(self.class.get(report_path, default_headers))
    end
  end
end
