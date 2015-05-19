class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.belongs_to :artist, index: true

      t.timestamps null: false
    end
    add_foreign_key :songs, :artists
  end
end
