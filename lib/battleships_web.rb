require 'sinatra/base'
require 'battleships'
require "sinatra/session"

class BattleshipsWeb < Sinatra::Base
  # force port 3000 for Nitrous
  configure :development do
    set :bind, '0.0.0.0'
    set :port, 3000
  end
  $players = 0
  enable :sessions
  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/name_set' do
    @name = params[:name]
    erb :enter_name
  end

  get "/online" do
    erb :online
  end

  get "/online/p1place" do
    @player = session[:p1]
    @p=($game).player_1.board.ships.map { |x| (x.type) }
    erb :onlineplace
  end

  get "/online/p2place" do
    @player = session[:p2]
    @p=($game).player_2.board.ships.map { |x| (x.type) }
    erb :onlineplace
  end

  post "/online/p1place" do
    @player = session[:p1]
    p=($game).player_1.board.ships.map { |x| (x.type) }
    if !p.include?(:aircraft_carrier)
      ($game).player_1.place_ship Ship.aircraft_carrier, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:battleship)
      ($game).player_1.place_ship Ship.battleship, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:cruiser)
      ($game).player_1.place_ship Ship.cruiser, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:destroyer)
      ($game).player_1.place_ship Ship.destroyer, params[:location].capitalize.to_sym, params[:direction].to_sym
    end
    @p=($game).player_1.board.ships.map { |x| (x.type) }
    erb :onlineplace
  end
  post "/online/p2place" do
    @player = session[:p2]
    p=($game).player_2.board.ships.map { |x| (x.type) }
    if !p.include?(:aircraft_carrier)
      ($game).player_2.place_ship Ship.aircraft_carrier, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:battleship)
      ($game).player_2.place_ship Ship.battleship, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:cruiser)
      ($game).player_2.place_ship Ship.cruiser, params[:location].capitalize.to_sym, params[:direction].to_sym
    elsif !p.include?(:destroyer)
      ($game).player_2.place_ship Ship.destroyer, params[:location].capitalize.to_sym, params[:direction].to_sym
    end
    @p=($game).player_2.board.ships.map { |x| (x.type) }
    erb :onlineplace
  end
  post "/online/playp1" do
    ($game).player_1.place_ship Ship.submarine, params[:location].capitalize.to_sym, params[:direction].to_sym 
    erb :playp1
  end
  post "/online/playp2" do 
    ($game).player_2.place_ship Ship.submarine, params[:location].capitalize.to_sym, params[:direction].to_sym
    erb :playp2
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
    p1 = session[:game].player_1.board.ships.map { |x| (x.type) }
    p2 = session[:game].player_2.board.ships.map { |x| (x.type) }
    if !p1.include?(:submarine)
      p = p1
    else
      p = p2
    end
    if !p.include?(:aircraft_carrier)
      p1.include?(:aircraft_carrier) ? (session[:game].player_2.place_ship Ship.aircraft_carrier, params[:location].capitalize.to_sym, params[:direction].to_sym) : (session[:game].player_1.place_ship Ship.aircraft_carrier, params[:location].capitalize.to_sym, params[:direction].to_sym)
    elsif !p.include?(:battleship)
      p1.include?(:battleship) ? (session[:game].player_2.place_ship Ship.battleship, params[:location].capitalize.to_sym, params[:direction].to_sym) : (session[:game].player_1.place_ship Ship.battleship, params[:location].capitalize.to_sym, params[:direction].to_sym)
    elsif !p.include?(:cruiser)
      p1.include?(:cruiser) ? (session[:game].player_2.place_ship Ship.cruiser, params[:location].capitalize.to_sym, params[:direction].to_sym) : (session[:game].player_1.place_ship Ship.cruiser, params[:location].capitalize.to_sym, params[:direction].to_sym)
    elsif !p.include?(:destroyer)
      p1.include?(:destroyer) ? (session[:game].player_2.place_ship Ship.destroyer, params[:location].capitalize.to_sym, params[:direction].to_sym) : (session[:game].player_1.place_ship Ship.destroyer, params[:location].capitalize.to_sym, params[:direction].to_sym)
    else
      session[:game].player_1.place_ship Ship.submarine, params[:location].capitalize.to_sym, params[:direction].to_sym
    end
    erb :place_ships
  end
  
  post "/pvp/play" do
    session[:game].player_2.place_ship Ship.submarine, params[:location].capitalize.to_sym, params[:direction].to_sym
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