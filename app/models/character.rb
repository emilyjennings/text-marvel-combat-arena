class Character
  include HTTParty
  base_uri 'gateway.marvel.com:80'

  def self.character(id)
    response =
        self.get("/v1/public/characters/#{id}?#{MarvelParams.credentials}")
    response_body = JSON.parse(response.body)
    results = response_body['data']['results'][0]
  end

  def self.all_characters
    response =
        self.get("/v1/public/characters?#{MarvelParams.credentials}")
    response_body = JSON.parse(response.body)
    results = response_body['data']['results']
  end
end
