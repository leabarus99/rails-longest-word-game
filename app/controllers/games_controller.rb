require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @proposition = params[:proposition]
    @letters = params[:letters]
    score_proposition = score_proposition(@proposition, @letters)
    @score = score_proposition[0]
    @message = score_proposition[1]
  end

  def included(proposition, letters)
    proposition.chars.all? { |letter| proposition.count(letter) <= letters.count(letter) }
  end

  def english_word(proposition)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{proposition}")
    json = JSON.parse(response.read)
    json['found']
  end

  def score_proposition(proposition, letters)
    if included(proposition.upcase, letters) && english_word(proposition)
      score = proposition.size
      [score, "Congratulations! #{proposition.upcase} is a valid English word!"]
    elsif english_word(proposition) == false
      [0, "Sorry but #{proposition.upcase} does not seem to be a valid English word..."]
    else
      [0, "Sorry but #{proposition.upcase} can't be built out of #{letters.tr('[]', '').gsub('"', ' ')}"]
    end
  end
end
