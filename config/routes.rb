Rails.application.routes.draw do
  scope :module => 'foreman_gutterball', :path => '/katello' do
    scope :module => 'api' do
      scope :module =>  'v2' do
        resources :content_reports, :only => [:index] do
          collection do
            get :consumer_status
            get :consumer_trend
            get :status_trend
          end
        end
      end
    end
  end
end
