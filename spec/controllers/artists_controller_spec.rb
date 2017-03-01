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

  describe '#reformat' do

    let(:ids) { [Faker::Number.number(8), Faker::Number.number(8), Faker::Number.number(8)] }
    let(:names) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }
    let(:spotifies) { %W(https://open.spotify.com/artist/#{Faker::Number.number(4)} https://open.spotify.com/artist/#{Faker::Number.number(4)} https://open.spotify.com/artist/#{Faker::Number.number(4)}) }
    let(:genres) { ["mellow gold", 'permanent wave', "pop christmas", 'soft rock'] }

    let(:artist0) {
      double id: ids[0],
             name: names[0],
             external_urls: {
                 spotify: spotifies[0]
             },
             genres: genres,
             albums: [],
             popularity: 20,
             type: "artist",
             uri: "spotify:artist:5e8e4l6G9xt5BqjbDJocZF",
             followers: {
                 href: 'http://someurl/',
                 total: 322
             }
    }
    let(:artist1) {
      double id: ids[1],
             name: names[1],
             external_urls: {
                 spotify: spotifies[1]
             },
             genres: [genres[0], genres[1], genres[2]],
             albums: [],
             popularity: 20,
             type: "artist",
             uri: "spotify:artist:5e8e4l6G9xt5BqjbDJocZF",
             followers: {
                 href: 'http://someurl/',
                 total: 322
             }
    }
    let(:artist2) {
      double id: ids[2],
             name: names[2],
             external_urls: {
                 spotify: spotifies[2]
             },
             genres: [genres[0], genres[1]],
             albums: [],
             popularity: 20,
             type: "artist",
             uri: "spotify:artist:5e8e4l6G9xt5BqjbDJocZF",
             followers: {
                 href: 'http://someurl/',
                 total: 322
             }
    }
    let(:artists) {
      [artist0, artist1, artist2]
    }

    let(:formatted_artists) {
      [
          {id: ids[0],
           name: names[0],
           external_urls: {
               spotify: spotifies[0]
           },
           genres: genres
          },

          {id: ids[1],
           name: names[1],
           external_urls: {
               spotify: spotifies[1]
           },
           genres: [genres[0], genres[1], genres[2]],
          },

          {id: ids[2],
           name: names[2],
           external_urls: {
               spotify: spotifies[2]
           },
           genres: [genres[0], genres[1]],
          }
      ]
    }

    it 'maps the retrieved artists from Spotify to desired format' do
      expect(controller.reformat artists).to eq formatted_artists
    end
  end

end
