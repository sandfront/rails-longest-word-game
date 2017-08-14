class PlaysController < ApplicationController
  def game
    @grid_arr = generate_grid(9)
    @grid = @grid_arr.join(" ")
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @attempt = params[:guess]
    @result = run_game(@attempt, params[:grid], Time.parse(params[:start_time]), @end_time)
  end

  private


  def run_game(attempt, grid, start_time, end_time)
    score = 0
    if dictionary_word?(attempt) && input_in_grid?(attempt, grid)
      message = "well done!"
      score = (attempt.length * 20) - (end_time - start_time)
    elsif dictionary_word?(attempt) && !input_in_grid?(attempt, grid)
      message = "not in the grid"
    else
      message = "not an english word"
    end

    return { time: end_time - start_time, score: score, message: message }
  end



























  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times do
      grid << ("A".."Z").to_a.sample
    end
    grid
  end

  def dictionary_word?(word)
    check_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized_dic_json = open(check_url).read
    dic = JSON.parse(serialized_dic_json)
    if dic["found"] == true
      return true
    else
      return false
    end
  end

  def count_letters_in(input)
    my_hash = Hash.new(0)
    input = input.join if input.class == Array
    input.split("").each do |l|
      my_hash[l] += 1
    end
    return my_hash
  end

  def input_in_grid?(word, grid)
    word = word.upcase
    word.split("").all? do |l|
      count_letters_in(word)[l] <= count_letters_in(grid)[l]
    end
  end

end
