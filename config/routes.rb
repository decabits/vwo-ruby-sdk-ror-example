Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'basic_example', to: 'home#basic_example'
  get 'user_defined_logger', to: 'home#user_defined_logger_example'
  get 'user_storage', to: 'home#user_storage_example'
  get 'ab', to: 'home#ab'
  get 'feature-rollout', to: 'home#feature_rollout_campaign'
  get 'feature-test', to: 'home#feature_campaign'
  get 'push', to: 'home#push_api'
end
