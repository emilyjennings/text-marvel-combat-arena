require 'pry'
#used pry in my API calls, especially in the beginning I was having trouble with the MDN digest for the hash parameter. Figured out by using pry that the call wasn't going through

class CharactersController < ApplicationController
  def play
  end

  #spent time here wondering if I should use the marvel_api gem with Faraday, but decided it had last been updated 3-5 years ago and I may run into issues, taking precious time away from making this app which was due in 3 days.


  def character_play
    public_key = ENV['public_key']
    private_key = ENV['private_key']
    timestamp = DateTime.now.to_s
    hash = Digest::MD5.hexdigest( "#{timestamp}#{private_key}#{public_key}" )
    #I spent a fair amount of time looking at the Marvel API documentation to figure out how they wanted the hash digested, and even get help at the meetup I went to during this project on the MD5 digest
    #I looked at other repos on github that had used the Marvel API to see how they called it as well

    #Below, you'll see the two characters chosen by the players and that they're found in the Marvel universe via the API request and then this makes it possible to put their details in the views
    begin
    @resp_one = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
      req.params['name'] = params[:character_one]
    end

    character_one = JSON.parse(@resp_one.body)

    @character_one = character_one['data']['results']
    #I want to refactor this later so the winner shows on another page by redirect
    #For now, the number chosen is used immediately to give the winner. i think it would be better to have that somehow delayed so you see who's battling first then click another button to get the winner.
    @word_one = @character_one[0]['description'].split(' ')[params[:num].to_i]
    @all_words_one = @character_one[0]['description'].split(' ')


    @resp_two = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
      req.params['ts'] = timestamp
      req.params['apikey'] = public_key
      req.params['hash'] = hash
      req.params['name'] = params[:character_two]
    end

    character_two = JSON.parse(@resp_two.body)

    @character_two = character_two['data']['results']
    @word_two = @character_two[0]['description'].split(' ')[params[:num].to_i]
    @all_words_two = @word_two = @character_two[0]['description'].split(' ')
    #I decided to compare the word_one and word_two variables in the view but I think I could easily put those conditional statements here

    render 'play'
    #both characters are identified! The play view is reloaded with the proper info/images


    #an error mesage in case there's a timeout
    rescue Faraday::ConnectionFailed
      @error = "There was a timeout. Please try again."
    end

  end

  def index
    #this is just a rendering with a search form for someone to enter the first few letters of a character to find them
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
      #The Marvel API is cool because it allows this kind of a search with an incomplete spelling of a character name.
    end

    characters = JSON.parse(@resp.body)

    @characters = characters['data']['results']
    #renders the page again with the search results. For some reason if there's a lot of results, it only will load the first 20. The API has set that as the limit. That's why this search form is so important so people can find the characters they want.
    render 'index'
  end

  # def winner
  #   num = params[:num].to_i
  #   word_one = @character_one[0]['description'].split(' ')[num]
  #   render 'winner'
  # end

end
