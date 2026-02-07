class CreateGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :genres, :slug, unique: true
  end
end
