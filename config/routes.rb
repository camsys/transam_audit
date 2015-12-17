Rails.application.routes.draw do

  resources :audits
  resources :audit_results, :only => [:index]

end
