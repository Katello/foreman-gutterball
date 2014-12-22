require 'deface'

module ForemanGutterball
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer "foreman_gutterball.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanGutterball::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_gutterball.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_gutterball do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_gutterball do
          permission :view_foreman_gutterball, {:'foreman_gutterball/hosts' => [:new_action] }
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role "ForemanGutterball", [:view_foreman_gutterball]

        #add menu entry
        menu :top_menu, :template,
             :url_hash => {:controller => :'foreman_gutterball/hosts', :action => :new_action },
             :caption  => 'ForemanGutterball',
             :parent   => :hosts_menu,
             :after    => :hosts

        # add dashboard widget
        widget 'foreman_gutterball_widget', :name=>N_('Foreman plugin template widget'), :sizex => 4, :sizey =>1
      end
    end

    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanGutterball::HostExtensions)
        HostsHelper.send(:include, ForemanGutterball::HostsHelperExtensions)
      rescue => e
        puts "ForemanGutterball: skipping engine hook (#{e.to_s})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanGutterball::Engine.load_seed
      end
    end

  end
end
