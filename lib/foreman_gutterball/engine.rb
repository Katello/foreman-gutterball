module ForemanGutterball
  class Engine < ::Rails::Engine
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_gutterball.load_app_instance_data' do |app|
      app.config.paths['db/migrate'] += ForemanGutterball::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_gutterball.register_plugin', :after => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_gutterball do
        requires_foreman '>= 1.4'
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        # TODO: remove rubocop disable once begin block has content
      rescue => e # rubocop:disable Style/IndentationWidth
        Rails.logger.warn "ForemanGutterball: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanGutterball::Engine.load_seed
      end
    end
  end
end
