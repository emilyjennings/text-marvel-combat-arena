require 'pry'
#used pry in my API calls, espcially in the beginning I was having trouble with the MDN digest for the hash parameter. Figured out by using pry that the call wasn't going through

class CharactersController < ApplicationController
  def play
  end

  #spent time here wondering if I should use the marvel_api gem with Faraday, but decided it had last been updated 3-5 years ago and I may run into issues, taking precious time away from making this app which was due in 3 days.


  def character_play
    public_key = ENV['public_key']
    private_key = ENV['private_key']
    timestamp = DateTime.now.to_s
    hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )

    begin
    @resp_one = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
      req.params['name'] = params[:character_one]
    end

    character_one = JSON.parse(@resp_one.body)

    @character_one = character_one['data']['results']


    @resp_two = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
      req.params['name'] = params[:character_two]
    end

    character_two = JSON.parse(@resp_two.body)

    @character_two = character_two['data']['results']

    render 'play'

    rescue Faraday::ConnectionFailed
      @error = "There was a timeout. Please try again."
    end

  end

  def index
  end

  def searchByLetter
    public_key = ENV['public_key']
    private_key = ENV['private_key']
    timestamp = DateTime.now.to_s
    hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )

    @resp = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
      req.params['nameStartsWith'] = params[:letter]
    end

    characters = JSON.parse(@resp.body)

    @characters = characters['data']['results']
    render 'index'
  end

end
