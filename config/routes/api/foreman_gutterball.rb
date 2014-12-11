ForemanGutterball::Engine.routes.draw do
  # scope :gutterball, :path => '/gutterball' do
  # end

  scope :katello, :path => '/katello' do
    namespace :api do
      scope('(:api_version)',
        :module => :v2,
        :defaults => { :api_version => 'v2' },
        :api_version => /v2/,
        :constraints => ApiConstraints.new(:version => 2, :default => true)) do

        api_resources :content_reports, :only => [:index, :show] do
          member do
            get :generate
          end
        end

      end
    end
  end

end
