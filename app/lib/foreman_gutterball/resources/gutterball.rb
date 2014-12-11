#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

# rubocop:disable SymbolName
module ForemanGutterball
  module Resources

    require 'rest_client'

    class GutterballResource < HttpResource # possibly extend CandlepinResource
      cfg = Katello.config.gutterball
      url = cfg.url
      self.prefix = URI.parse(url).path
      self.site = url.gsub(self.prefix, "")
      self.consumer_secret = cfg.oauth_secret
      self.consumer_key = cfg.oauth_key
      self.ca_cert_file = cfg.ca_cert_file

      class << self
        def base_url
          '/gutterball'
        end

        def logger
          ::Logging.logger['gb_rest']
        end

        def default_headers
          cp_oauth_header = User.cp_oauth_header
          cp_oauth_header = {}

          {'accept' => 'application/json',
           'accept-language' => I18n.locale,
           'content-type' => 'application/json'}.merge(cp_oauth_header)
        end
      end
    end

    class ContentReports < GutterballResource
      class << self

        def path(*tokens)
          join_path("#{self.base_url}/reports", *tokens)
        end

        def index
          JSON.parse(self.get(path, self.default_headers).body).map(&:with_indifferent_access)
        end

        def find(key)
          JSON.parse(self.get(path(key), self.default_headers).body).with_indifferent_access
        end

        def run_report(key, query_params = {})
          response = self.get(path(key, 'run') + hash_to_query(query_params), self.default_headers)
          JSON.parse(response.body).with_indifferent_access
        end
      end
    end

  end
end
