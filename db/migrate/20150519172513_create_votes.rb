class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs :song

      t.timestamps null: false
    end
  end
end
