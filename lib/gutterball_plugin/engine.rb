module GutterballPlugin
  class Engine < ::Rails::Engine
    isolate_namespace GutterballPlugin

    initializer 'gutterball_plugin.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{GutterballPlugin::Engine.root}/config/mount_engine.rb"
    end

    initializer "gutterball_plugin.paths" do |app|
      app.routes_reloader.paths.unshift("#{GutterballPlugin::Engine.root}/config/routes/api/gutterball_plugin.rb")
      app.routes_reloader.paths.unshift("#{GutterballPlugin::Engine.root}/config/routes/overrides.rb")
    end

    # config.to_prepare do
    # end

    initializer 'gutterball_plugin.register_plugin', :after => :finisher_hook do
      require 'gutterball_plugin/plugin'
      require 'gutterball_plugin/permissions'
    end

  end
end
