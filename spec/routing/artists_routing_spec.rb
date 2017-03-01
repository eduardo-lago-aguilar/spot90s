describe ArtistsController, type: :routing do
  it { is_expected.to route(:get, '/artists/search/sting').to action: :search, query: 'sting'  }
  it { is_expected.to route(:get, '/artists/5e8e4l6G9xt5BqjbDJocZF').to action: :show, spotify_id: '5e8e4l6G9xt5BqjbDJocZF' }
  it { is_expected.to route(:put, '/artists/5e8e4l6G9xt5BqjbDJocZF').to action: :favorite, spotify_id: '5e8e4l6G9xt5BqjbDJocZF' }
  it { is_expected.to route(:get, '/').to action: :default }
end
