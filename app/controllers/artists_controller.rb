class ArtistsController < ApplicationController

  def search
    render json: reformat(perform_search(params[:query]))
  end

  def show
    artist = find(params[:spotify_id])
    render json: reformat([artist]).first
  end

  def perform_search(query)
    RSpotify::Artist.search query
  end

  def find(spotify_id)
    RSpotify::Artist.find spotify_id
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
