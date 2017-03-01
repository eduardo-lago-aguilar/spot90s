class ArtistsController < ApplicationController

  def search
    render json: reformat(perform_search(params[:query]))
  end

  def show
    artist = find(params[:spotify_id])
    render json: reformat([artist]).first
  end

  def default
    render json: reformat([perform_search('e').first]).first
  end

  def favorite
    render json: mark_as_favorite(params[:spotify_id])
  end

  def perform_search(query)
    RSpotify::Artist.search query
  end

  def find(spotify_id)
    RSpotify::Artist.find spotify_id
  end

  def mark_as_favorite(spotify_id)
    spotify_artist = reformat([find(spotify_id)]).first
    lookup_artist = Artist.find_by spotify_id: spotify_id
    if lookup_artist.present?
      lookup_artist.update! spotify: spotify_artist.to_s, favorite: true
    else
      Artist.create! spotify_id: spotify_id, spotify: spotify_artist.to_s, favorite: true
    end
    spotify_artist
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
