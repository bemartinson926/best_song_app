class AddOptimalVolumetoSongs < ActiveRecord::Migration
  def change
    add_column :songs, :optimal_volume, :string
  end
end
