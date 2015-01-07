require 'rest_client'

module ForemanGutterball
  class GutterballService
    def self.logger
      ::Logger.logger['gutterball_service']
    end

    # rubocop:disable Style/CyclomaticComplexity
    def initialize(options = {})
      cfg = SETTINGS['foreman_gutterball'].with_indifferent_access
      url = cfg.url

      def_headers = {
        'accept' => 'application/json',
        'accept-language' => I18n.locale,
        'content-type' => 'application/json'
      }.merge(User.cp_oauth_headers)

      @consumer_secret = options[:consumer_secret] || cfg.oauth_secret
      @consumer_key = options[:consumer_key] || cfg.oauth_key
      @ca_cert_file = options[:ca_cert_file] || cfg.ca_cert_file
      @prefix = options[:prefix] || URI.parse(url).path
      @site = options[:site] || url.gsub(@prefix, '')
      @default_headers = options[:default_headers] || def_headers

      logger.debug 'initializing GutterballService with options:'
      logger.debug "    consumer_secret: #{@consumer_secret}"
      logger.debug "    consumer_key:    #{@consumer_key}"
      logger.debug "    ca_cert_file:    #{@ca_cert_file}"
      logger.debug "    prefix:          #{@prefix}"
      logger.debug "    site:            #{@site}"
      logger.debug "    default_headers: #{@default_headers}"
    end

    def available_reports
      # "GET /reports"
      get('', '', '')
    end

    # def valid_parameters(report_key)
    def valid_parameters(*)
      # "GET /reports/:report_key"
      get('', '', '')
    end

    # def report(report_key, params = {})
    def report(*)
      # "GET /reports/:report_key/run?param1=v1&param2=v2[...]"
      get('', '', '')
    end

    private

    attr_reader :consumer_secret, :consumer_key, :ca_cert_file, :prefix, :site, :default_headers

    # def get(path, params, headers)
    def get(*)
      # restclient GET
    end
  end
end
