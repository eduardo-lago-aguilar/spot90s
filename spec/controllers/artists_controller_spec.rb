describe ArtistsController, type: :controller do

  let(:query) { Faker::Name.name }
  let(:artists) { [Faker::Name.name, Faker::Name.name, Faker::Name.name] }

  let(:artist) { Faker::Name.name }
  let(:formatted_artist) { {name: Faker::Name.name, id: Faker::Number.number(8)} }

  let(:spotify_id) { Faker::Number.number(8) }

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

  describe '#show' do
    it 'retrieves and specific artists given the spotity id' do
      expect(controller).to receive(:find).with(spotify_id).and_return artist
      expect(controller).to receive(:reformat).with([artist]).and_return [formatted_artist]

      get :show, params: {spotify_id: spotify_id}

      expect(response.body).to eq formatted_artist.to_json
    end
  end

  describe '#find' do
    it 'delegates the search to RSpotify API' do
      expect(RSpotify::Artist).to receive(:find).with(spotify_id).and_return artist
      expect(controller.find spotify_id).to eq artist
    end

  end

  describe '#default' do
    let(:artist) {
      double id: Faker::Number.number(10)
    }

    it 'retrieves a first artist matching the e letter' do
      expect(controller).to receive(:perform_search).with('e').and_return artists
      expect(controller).to receive(:reformat).with([artists[0]]).and_return [formatted_artist]
      get :default
      expect(response.body).to eq formatted_artist.to_json
    end
  end

  describe '#favorite' do
    it 'stores the artist as favorite' do
      expect(controller).to receive(:mark_as_favorite).with(spotify_id).and_return formatted_artist
      put :favorite, params: {spotify_id: spotify_id}
      expect(response.body).to eq formatted_artist.to_json
    end
  end

  describe '#mark_as_favorite' do
    before do
      expect(controller).to receive(:find).with(spotify_id).and_return artist
      expect(controller).to receive(:reformat).with([artist]).and_return [formatted_artist]
    end

    describe 'artists non existing on database' do
      it 'retrieves the artist from spotify and stored it on db as favorite' do
        controller.mark_as_favorite spotify_id
        expect(Artist.count).to eq 1
        expect(Artist.take.spotify_id).to eq spotify_id
        expect(Artist.take.spotify).to eq formatted_artist.to_s
        expect(Artist.take.favorite).to eq true
      end
    end

    describe 'artists already existing on database' do
      it 'retrieves the artist from spotify and stored it on db as favorite' do
        Artist.create! spotify_id: spotify_id, spotify: formatted_artist.to_s

        controller.mark_as_favorite spotify_id
        expect(Artist.count).to eq 1
        expect(Artist.take.spotify_id).to eq spotify_id
        expect(Artist.take.spotify).to eq formatted_artist.to_s
        expect(Artist.take.favorite).to eq true
      end
    end

  end

end
