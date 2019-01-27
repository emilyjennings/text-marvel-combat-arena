require 'pry'
#used pry in my API calls, especially in the beginning I was having trouble with the MDN digest for the hash parameter. Figured out by using pry that the call wasn't going through

class CharactersController < ApplicationController
  def play
  end

  #spent time here wondering if I should use the marvel_api gem with Faraday, but decided it had last been updated 3-5 years ago and I may run into issues, taking precious time away from making this app which was due in 3 days.


  def character_play
    if params[:character_one].empty? || params[:character_two].empty? || params[:num].empty?
      @error = "You need to enter all parameters for this game to work."
      render 'play'
    else
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


      @resp_two = Faraday.get 'http://gateway.marvel.com/v1/public/characters' do |req|
        req.params['ts'] = timestamp
        req.params['apikey'] = public_key
        req.params['hash'] = hash
        req.params['name'] = params[:character_two]
      end

      character_two = JSON.parse(@resp_two.body)

      #This was hard to make error messages because it turns out if someone tries to find a character name that isn't in the database, it's still a response code of 200. I left this here for cases when it just isn't 200, but made a new error system below.
      if character_one["code"] != 200
        @error = character_one["status"] || character_one["message"]
      elsif character_two["code"] != 200
        @error = character_two["status"] || character_two["message"]
      end


      @character_one = character_one['data']['results']
      @character_two = character_two['data']['results']

      #error cases for when the character isn't found
      if @character_two.empty? || @character_one.empty?
        @error = "One of these characters is not spelled right or doesn't exist."
      elsif @resp_one.success? && @resp_two.success?
        #I want to refactor this later so the winner shows on another page by redirect
        #For now, the number chosen is used immediately to give the winner. i think it would be better to have that somehow delayed so you see who's battling first then click another button to get the winner.
        @word_one = @character_one[0]['description'].split(' ')[params[:num].to_i]
        @all_words_one = @character_one[0]['description'].split(' ')
        @word_two = @character_two[0]['description'].split(' ')[params[:num].to_i]
        @all_words_two = @word_two = @character_two[0]['description'].split(' ')
      end
      #I decided to compare the word_one and word_two variables in the view for the winner but I think I could easily put those conditional statements here


      #an error mesage in case there's a timeout
      rescue Faraday::ConnectionFailed
        @error = "There was a timeout. Please try again."

      rescue Faraday::Response::RaiseError
        @error = "There was a problem finding that. Please try again."
      end

      #both characters are identified! The play view is rendered with the proper info/images
      render 'play'
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

  # This could be used later when refactoring and using sessions
  # def winner
  #   num = params[:num].to_i
  #   word_one = @character_one[0]['description'].split(' ')[num]
  #   render 'winner'
  # end

end
