describe ArtistsController, type: :controller do

  let(:query) { Faker::Name.name }
  let(:artists) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }

  describe '#search' do
    let(:formatted_artists) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }

    it 'performs a search on spotify and reformat the results' do
      expect(controller).to receive(:perform_search).with(query).and_return artists
      expect(controller).to receive(:reformat).with(artists).and_return formatted_artists
      get :search, params: {query: query}
      expect(response.body).to eq formatted_artists.to_json
    end
  end

  describe '#perform_search' do
    it 'delegates the search to RSpotify API' do
      expect(RSpotify::Artist).to receive(:search).with(query).and_return artists
      expect(controller.perform_search query).to eq artists
    end
  end

end
