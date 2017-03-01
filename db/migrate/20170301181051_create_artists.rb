class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.boolean :favorite
      t.string :spotify
      t.string :spotify_id
      t.timestamps
    end
  end
end
