require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @userinput = params[:guess]
    @letters = params[:letters]
    session[:score] = session[:score] || 0
    if included?(@userinput.upcase, @letters)
      if english_word?(@userinput)
        @output = "Congratulations! #{@userinput.upcase} is a valid English word!"
        session[:score] += compute_score(@userinput)
      else
        @output = "Sorry but #{@userinput.upcase} does not seem to be a valid English word!"
      end
    else
      @output = "Sorry but #{@userinput.upcase} cannot be built out of #{@letters}"
    end
      @score = session[:score]
  end

def reset_session
  session[:score] = 0
  redirect_to new_path
    end


    private

    def english_word?(word)
      response = open("https://wagon-dictionary.herokuapp.com/#{word}")
      json = JSON.parse(response.read)
      json['found']
    end

    def included?(guess, grid)
      guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
    end

    def compute_score(attempt)
      attempt.size * 2.0
    end
  end


