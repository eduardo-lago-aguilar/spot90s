describe ArtistsController, type: :controller do

  describe '#search' do
    let(:artists) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    let(:formatted_artists) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    let(:query) { Faker::Name.name }

    it 'performs a search on spotify and reformat the results' do
      expect(controller).to receive(:perform_search).with(query).and_return artists
      expect(controller).to receive(:reformat).with(artists).and_return formatted_artists
      get :search, params: {query: query}
      expect(response.body).to eq formatted_artists.to_json
    end
  end
end
