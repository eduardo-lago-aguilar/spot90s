class ArtistsController < ApplicationController

  def search
    render json: reformat(perform_search(params[:query]))
  end

  def perform_search(query)

  end

  def reformat(artists)

  end
end
