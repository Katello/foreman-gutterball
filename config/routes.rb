Rails.application.routes.draw do
  scope :module => 'foreman_gutterball', :path => '/katello' do
    scope :module => 'api' do
      scope :module =>  'v2' do
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
