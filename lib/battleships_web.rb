require 'sinatra/base'
require 'battleships'
require "sinatra/session"

class BattleshipsWeb < Sinatra::Base
  # force port 3000 for Nitrous
  configure :development do
    set :bind, '0.0.0.0'
    set :port, 3000
  end

  enable :sessions
  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_set' do
    @name = params[:name]
    erb :enter_name
  end

  get '/play' do   
    session[:game] = Game.new Player, Board
    session[:game].player_2.place_ship Ship.cruiser, :A1
    erb :game
  end

  post "/play" do
    @coordinates = params[:coordinates].capitalize
    erb :game
  end

  get "/pvp" do
    session[:game] = Game.new Player, Board
    erb :enter_name2
  end
  
  get "/pvp/placeships" do
    @name = params[:name]
    erb :place_ships
  end
  
  post "/pvp/placeships" do
    session[:game].player_1.place_ship Ship.aircraft_carrier, params[:location1].capitalize.to_sym, params[:direction1].to_sym
    session[:game].player_1.place_ship Ship.battleship, params[:location2].capitalize.to_sym, params[:direction2].to_sym
    session[:game].player_1.place_ship Ship.cruiser, params[:location3].capitalize.to_sym, params[:direction3].to_sym
    session[:game].player_1.place_ship Ship.destroyer, params[:location4].capitalize.to_sym, params[:direction4].to_sym
    session[:game].player_1.place_ship Ship.submarine, params[:location5].capitalize.to_sym, params[:direction5].to_sym
    erb :place_ships
  end
  
  post "/pvp/play" do
    session[:game].player_2.place_ship Ship.aircraft_carrier, params[:location1].capitalize.to_sym, params[:direction1].to_sym
    session[:game].player_2.place_ship Ship.battleship, params[:location2].capitalize.to_sym, params[:direction2].to_sym
    session[:game].player_2.place_ship Ship.cruiser, params[:location3].capitalize.to_sym, params[:direction3].to_sym
    session[:game].player_2.place_ship Ship.destroyer, params[:location4].capitalize.to_sym, params[:direction4].to_sym
    session[:game].player_2.place_ship Ship.submarine, params[:location5].capitalize.to_sym, params[:direction5].to_sym
    erb :play
  end

  get "/pvp/play/p1turn" do
    erb :p1turn
  end

  post "/pvp/play/p1turn" do
    @coordinates = params[:coordinates].capitalize
    erb :p1turn
  end

  get "/pvp/play/p2turn" do
    erb :p2turn
  end

  post "/pvp/play/p2turn" do
    @coordinates = params[:coordinates].capitalize
    erb :p2turn
  end
  # start the server if ruby file executed directly
  run! if app_file == $0

end