# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  resources :users, only: [:edit, :update]
  get '/users/logout', to: 'sessions#destroy', as: :user_logout

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get '/auth/failure', to: 'landing#auth_failure'

  # There are two resources [meetings|rooms]
  # meetings offer a landing page for NON authenticated users to create and join session in BigBlueButton
  # rooms offer a customized landing page for authenticated users to create and join session in BigBlueButton
  get '/:resource/:id', to: 'landing#resource', as: :resource
  get '/:resource/:id/join', to: 'bbb#join', as: :bbb_join, defaults: {format: 'json'}
  get '/:resource/:id/wait', to: 'landing#wait_for_moderator'
  get '/:resource/:id/session_status_refresh', to: 'landing#session_status_refresh'
  delete '/rooms/:id/end', to: 'bbb#end', defaults: {format: 'json'}
  get '/rooms/:id/recordings', to: 'bbb#recordings', defaults: {format: 'json'}
  patch '/rooms/:id/recordings/:record_id', to: 'bbb#update_recordings', defaults: {format: 'json'}
  delete '/rooms/:id/recordings/:record_id', to: 'bbb#delete_recordings', defaults: {format: 'json'}

  root to: 'landing#index', :resource => "meetings"
end
