module CharactersHelper
  def name(character)
    character[0]['name']
  end

  def description(character)
    character[0]["description"]
  end
end
