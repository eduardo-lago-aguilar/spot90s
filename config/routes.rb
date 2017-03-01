Rails.application.routes.draw do

  # artists
  get '/artists/search/:query', controller: :artists, action: :search
  get '/artists/:spotify_id', controller: :artists, action: :show
  put '/artists/:spotify_id', controller: :artists, action: :favorite
  root controller: :artists, action: :default
end
