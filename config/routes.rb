Rails.application.routes.draw do
  scope :module => 'foreman_gutterball', :path => '/katello' do
    scope :module => 'api' do
      scope :module =>  'v2' do
        resources :content_reports,
          :only => [:index, :show],
          :constraints => { :id => /(status_trend|consumer_trend|consumer_status)/i } do
          get :run, :on => :member
        end
      end
    end
  end
end
