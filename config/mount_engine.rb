Foreman::Application.routes.draw do
  mount ForemanGutterball::Engine, :at => "/", :as => "foreman_gutterball"
end
