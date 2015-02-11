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
        requires_foreman '>= 1.7'
      end
    end

    initializer 'foreman_gutterball.apipie' do
      Apipie.configuration.api_controllers_matcher << "#{ForemanGutterball::Engine.root}" \
        '/app/controllers/foreman_gutterball/api/v2/*.rb'
      Apipie.configuration.checksum_path += ['/foreman_gutterball/api/']
      require 'foreman_gutterball/apipie/validators'
    end

    initializer 'foreman_gutterball.register_actions', :before => 'foreman_tasks.initialize_dynflow' do
      ForemanTasks.dynflow.require!
      ForemanTasks.dynflow.config.eager_load_paths.concat(["#{ForemanGutterball::Engine.root}/app/lib/foreman_gutterball/actions"])
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanGutterball::Engine.load_seed
      end
    end
  end
end
