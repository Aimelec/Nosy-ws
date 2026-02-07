class GameImporter
  class ImportError < StandardError; end

  def initialize(adapter_class:)
    @adapter_class = adapter_class
  end

  def import(external_data)
    adapter = @adapter_class.new(external_data)
    game_attrs = adapter.to_game_attributes

    ActiveRecord::Base.transaction do
      game = find_or_initialize_game(game_attrs)
      game.assign_attributes(game_attrs)
      game.genres = import_genres(adapter.genre_data)
      game.save!
      game
    end
  rescue ActiveRecord::RecordInvalid => e
    raise ImportError, "Failed to import game: #{e.message}"
  end

  def import_batch(external_data_array)
    results = { success: [], failed: [] }

    external_data_array.each do |data|
      game = import(data)
      results[:success] << game
    rescue ImportError => e
      results[:failed] << { data: data, error: e.message }
    end

    results
  end

  private

  def find_or_initialize_game(attrs)
    if attrs[:igdb_id]
      Game.find_or_initialize_by(source: attrs[:source], igdb_id: attrs[:igdb_id])
    else
      Game.new
    end
  end

  def import_genres(genre_data)
    genre_data.map do |genre_hash|
      Genre.find_or_create_from_slug(name: genre_hash[:name], slug: genre_hash[:slug])
    end
  end
end
