require 'sinatra/base'
require_relative 'game'

class RockPaper < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }
  set :public_folder, Proc.new { File.join(root, "../public") }
  enable :sessions
  GAME = Game.new

  get '/' do
    'Please enter your name'
    erb :enter_name
  end

  post '/play_game' do
    if params[:your_name] == ''
      redirect '/'
    end
    
    GAME.add_player(@player = Player.new(params[:your_name]))
    GAME.add_player(@computer = Player.new('computer').random_choice!)
    session[:game] = GAME
    session[:player] = @player
    session[:opponent] = @computer
    @buttons = CHOICES.map {|choice| button_link(choice)}
    erb :player_make_choice_picture
  end

  post '/play' do
    GAME.player1.choice = params[:pick].to_sym
    @player = session[:player]
    @opponent = session[:opponent]
    @winner = GAME.winner.nil? ? 'draw' : GAME.winner
    erb :show_result  
  end

  get '/play' do
    'why are we showing get when method is post?'
  end
  

  def button_link(choice)
    # return "<img id=#{choice} src='/images/#{choicemall.jpg\' alt='#{choice}' width='300' height='200'>"}_s
    # return "<a href ='/play' method='POST' type='submit' name='pick' value='#{choice.to_sym}'> alt='#{choice}'/></a>"
    return "<input type='image' src='images/#{choice.to_s.downcase}_small.jpg' alt='#{choice}' width='75' height='100' name='pick' value='#{choice.to_sym}'>"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
