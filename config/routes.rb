Rails.application.routes.draw do
 root 'webhook#index'
 post '/callback' => 'webhook#callback'
end
