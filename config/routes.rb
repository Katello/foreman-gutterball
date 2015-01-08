Rails.application.routes.draw do

  scope :module => 'foreman_gutterball', :path => '/gutterball' do
    resources :content_reports, :only => [:index, :show] do
      member do
        get :generate
      end
    end
  end

end
