class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.bigint :igdb_id
      t.string :source, null: false, default: "igdb"

      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.string :cover_image_url
      t.decimal :user_rating, precision: 4, scale: 2
      t.date :release_date

      t.string :platforms, array: true, default: []
      t.string :developers, array: true, default: []

      t.timestamps
    end

    add_index :games, :slug, unique: true
    add_index :games, :igdb_id
    add_index :games, [ :source, :igdb_id ], unique: true
    add_index :games, :platforms, using: :gin
  end
end
