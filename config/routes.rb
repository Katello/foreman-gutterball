Rails.application.routes.draw do
  scope :module => 'foreman_gutterball', :path => '/katello' do
    namespace :api do
      scope '(:api_version)',
        :module => :v2,
        :defaults => { :api_version => 'v2' },
        :api_version => /v2/,
        :constraints => ApiConstraints.new(:version => 2, :default => true) do
        resources :content_reports, :only => [] do
          collection do
            get :system_status
            get :system_trend
            get :status_trend
          end
        end
      end
    end
  end
end
