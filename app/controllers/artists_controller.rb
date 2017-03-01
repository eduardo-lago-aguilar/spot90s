class ArtistsController < ApplicationController

  def search
    render json: reformat(perform_search(params[:query]))
  end

  def perform_search(query)
    RSpotify::Artist.search query
  end

  def reformat(artists)
    artists.map do |artist|
      {
          id: artist.id,
          name: artist.name,
          external_urls: artist.external_urls,
          genres: artist.genres
      }
    end
  end
end
