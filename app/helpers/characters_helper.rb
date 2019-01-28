module CharactersHelper
  def name(character)
    character[0]['name']
  end

  def description(character)
    character[0]["description"]
  end

  def url(character)
    character[0]["urls"][0]["url"]
  end

  def img(character)
    character[0]['thumbnail']['path'] + '.jpg'
  end
end
