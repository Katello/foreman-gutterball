module ForemanGutterball
  class Engine < ::Rails::Engine
    isolate_namespace ForemanGutterball

    initializer 'foreman_gutterball.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{ForemanGutterball::Engine.root}/config/mount_engine.rb"
    end

    initializer 'foreman_gutterball.paths' do |app|
      app.routes_reloader.paths.unshift("#{ForemanGutterball::Engine.root}/config/routes/api/foreman_gutterball.rb")
      app.routes_reloader.paths.unshift("#{ForemanGutterball::Engine.root}/config/routes/overrides.rb")
    end

    # config.to_prepare do
    # end

    initializer 'foreman_gutterball.register_plugin', :after => :finisher_hook do
      require 'foreman_gutterball/plugin'
      require 'foreman_gutterball/permissions'
    end
  end
end
