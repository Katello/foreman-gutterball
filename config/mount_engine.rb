Foreman::Application.routes.draw do
  mount GutterballPlugin::Engine, :at => '/', :as => 'gutterball'
end
