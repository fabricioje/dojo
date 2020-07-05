Jets.application.routes.draw do
  resources :characters
  get  "/", to: "characters#get"
end
