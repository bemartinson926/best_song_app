class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :full_name
      t.string :current_hairstyle

      t.timestamps null: false
    end
  end
end
