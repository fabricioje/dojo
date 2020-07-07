Jets.application.routes.draw do
  resources :characters
  post  "/load", to: "characters#load"
  get  "/", to: "characters#show"
end
