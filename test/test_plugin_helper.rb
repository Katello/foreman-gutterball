# This calls the main test_helper in Foreman-core
require 'test_helper'
require 'rails/test_help'

# Add plugin to FactoryGirl's paths
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.reload
