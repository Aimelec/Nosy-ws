class IgdbGameImporter < GameImporter
  def initialize
    super(adapter_class: Igdb::GameAdapter)
  end
end
