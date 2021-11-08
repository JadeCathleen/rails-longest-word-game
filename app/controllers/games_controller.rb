require 'open-uri'
require 'json'

class GamesController < ApplicationController
  attr_accessor :grid

  def new
    @grid = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @grid = params.dig(:grid).split(',')
    @attempt = params[:word]

    serialized_attempt = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt.downcase}").read
    hash_attempt = JSON.parse(serialized_attempt)

    if hash_attempt['found'] && grid_include_attempt(@grid, @attempt) == false
      @answer = "Sorry but #{@attempt} can't be built out of #{@grid.join}"
    elsif hash_attempt['found'] == false
      @answer = "Sorry but #{@attempt} does not seem to be a valid English word.."
    else
      @answer = "Congratulations! #{@attempt} is a valid English word."
      @user_score = @attempt.upcase.chars.count
    end
  end

  private

  def grid_include_attempt(grid, attempt)
    attempt.upcase.chars.all? do |letter|
      attempt.upcase.chars.count(letter) <= grid.count(letter)
    end
  end
end
