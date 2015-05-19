class AddSongIdtoVote < ActiveRecord::Migration
  def change
    add_column :votes, :song_id, :integer
  end
end
