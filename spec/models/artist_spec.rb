describe Artist, type: :model do
  it { is_expected.to have_db_column(:favorite).of_type :boolean }
  it { is_expected.to have_db_column(:spotify).of_type :string }
  it { is_expected.to have_db_column(:spotify_id).of_type :string }
  it { is_expected.to validate_uniqueness_of :spotify_id }
end
