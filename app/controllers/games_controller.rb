# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @result = run_game(params[:word], params[:letters])
  end

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    grid
  end

  def check_grid?(attempt, grid)
    attempt.upcase.chars.all? { |letter| grid.count(letter) >= attempt.upcase.chars.count(letter) }
  end

  def call_api(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.parse(url).open.read
    JSON.parse(user_serialized)
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    word = call_api(attempt)
    if check_grid?(attempt, grid)
      score = word['found'] ? ((word['length'] * 10) / result[:time]) : 0
      message = word['found'] ? 'Well Done' : 'Your word is not an english word'
    else
      message = 'Your word is not in the grid'
      score = 0
    end
  end
end
