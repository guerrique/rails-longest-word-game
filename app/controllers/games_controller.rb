require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters_array = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters_array = params[:letters]
    @reply = params[:reply].upcase
    @score = get_score(@reply, @letters_array)
    @message = get_custom_message(@reply, @letters_array)
    # raise
  end
end

def check_word_in_grid(reply, letters_array)
  reply.chars.all? { |letter| reply.count(letter) <= letters_array.count(letter) }
  # attempt_a = reply.upcase.split("")
  # attempt_a.all? { |letter| attempt_a.count(letter) <= letters_array.count(letter) }
end

def check_word_true(reply)
  reply.downcase
  url = "https://wagon-dictionary.herokuapp.com/#{reply}"
  attempt_serialized = open(url).read
  attempt_status = JSON.parse(attempt_serialized)
  attempt_status["found"]
end

def check_attempt_success(reply, letters_array)
  check_word_in_grid(reply, letters_array) && check_word_true(reply)
end

def get_custom_message(reply, letters_array)
  # def get_custom_message(attempt)

  if check_attempt_success(reply, letters_array)
    "well done, your word is correct!"
  elsif check_word_in_grid(reply, letters_array) == false
    "your word is not in the grid!"
  elsif check_word_true(reply) == false
    "your word is not an english word!"
  end
end

def get_score(reply, letters_array)
  if check_attempt_success(reply, letters_array)
    score = reply.length * 2 + 1
    score
  else
    0
  end
end

# def run_game(attempt, grid)
#   # TODO: runs the game and return detailed hash of result
#   return {
#     score: get_score(attempt, grid, start_time, end_time),
#     message: get_custom_message(attempt, grid)
#   }
# end





