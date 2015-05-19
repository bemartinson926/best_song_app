class AddColumntoArtist < ActiveRecord::Migration
  def change
    add_column :artists, :home_town, :string
  end
end
