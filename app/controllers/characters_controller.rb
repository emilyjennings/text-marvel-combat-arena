require 'pry'

class CharactersController < ApplicationController
  def search
  end

  def character_search
    public_key = ENV['public_key']
    private_key = ENV['private_key']
    timestamp = DateTime.now.to_s
    hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )


    # begin
    @resp = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
    end

    characters = JSON.parse(@resp.body)

    @characters = characters['data']['results']

    # rescue Faraday::ConnectionFailed
    # @error = "There was a timeout. Please try again."
    # end
    render 'play'
  end
end
