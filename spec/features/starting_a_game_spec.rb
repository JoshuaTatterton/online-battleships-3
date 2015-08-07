require 'spec_helper'

feature 'Starting a new game' do
  scenario 'I am asked to enter my name' do
    visit '/'
    click_link 'New Game'
    expect(page).to have_content "What's your name?"
    our_name="Richard"
    fill_in "name", with: our_name
    click_button 'Submit'
    expect(page).to have_content "Hello, #{our_name}"
    $players = 0
  end
  scenario 'Gives default name if none submitted' do
    visit '/'
    click_link 'New Game'
    click_button 'Submit'
    expect(page).to have_content "Hello, Player 1"
    $players = 0
  end
  scenario "I can choose to start a game against a computer" do
    visit '/name_set'
    click_button 'Submit'
    click_link "VS Computer"
    expect(page).to have_content "Enter coordinates to fire upon"
    $players = 0
  end
  scenario "I can start a local game against a human opponent" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    expect(page).to have_content "What is player 2's name?"
    our_name="Josh"
    fill_in "name", with: our_name
    click_button 'Submit'
    expect(page).to have_content "Player 1 VS #{our_name}"
    $players = 0
  end
  scenario "I can start a online game against an opponent" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Online"
    expect(page).to have_content "Welcome Player 1, please place your ships while waiting for a second player to join."
    click_link "Place Ships"
    expect(page).to have_content "Please select ship location."
    visit "/name_set"
    click_button "Submit"
    click_link "PVP Online"
    expect(page).to have_content "Welcome Player 2, we've been waiting for you."
    click_link "Place Ships"
    expect(page).to have_content "Please select ship location."
    $players = 0
  end
end
feature 'Playing against computer' do
  scenario 'I can enter coordinates' do
    visit '/play'
    fire "A1"
    expect(page).to have_content "hit"
    fire "I7"
    expect(page).to have_content "miss"
  end
  scenario 'I can win' do
    visit '/play'
    fire "A1"
    fire "B1"
    fire "C1"
    expect(page).to have_content "Congratulations. You win!"
  end
  scenario 'I can start a new game after game ended' do
    visit '/play'
    fire "A1"
    fire "B1"
    fire "C1"
    expect(page).to have_link "New Game"
    click_link "New Game"
    expect(page).to have_content "Are you ready to play Battleships?"
  end
end
feature 'Playing against local human opponent' do
  scenario 'Player 1 can place ships' do
    $players = 0
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    click_button 'Submit'
    expect(page).to have_content "Player 1 please select ship locations."
    expect(page).to have_content "Aircraft Carrier: "
    placev "A1"
    expect(page).to have_content "Battleship: "
    placeh "D5"
    expect(page).to have_content "Cruiser: "
    placev "C1"
    expect(page).to have_content "Destroyer: "
    placeh "I5"
    expect(page).to have_content "Submarine: "
    placeh "J1"
    expect(page).to have_content "Player 2 please select ship locations."
  end
  scenario 'Player 2 can place ships' do
    $players = 0
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    click_button 'Submit'
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    expect(page).to have_content "Player 2 please select ship locations."
    expect(page).to have_content "Aircraft Carrier: "
    placev "A1"
    expect(page).to have_content "Battleship: "
    placeh "D5"
    expect(page).to have_content "Cruiser: "
    placev "C1"
    expect(page).to have_content "Destroyer: "
    placeh"I5"
    expect(page).to have_content "Submarine: "
    placeh "J1"
    expect(page).to have_content "Who will fire first?"
  end
  scenario "can select who goes first" do
    $players = 0
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    click_button 'Submit'
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    click_link 'Player 2'
    expect(page).to have_content "Player 2's turn"
  end
  scenario "a player can take a turn" do
    $players = 0
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    click_button 'Submit'
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    click_link "Player 1"
    fire "A1"
    expect(page).to have_content "hit"
    expect(page).to have_content "Player 2's turn"
  end
  scenario "a player can win the game" do
    $players = 0
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP Local"
    click_button 'Submit'
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    placev "A1"
    placeh "D5"
    placev "C1"
    placeh "I5"
    placeh "J1"
    click_link "Player 1"
    fire "A1"
    fire "A1"
    fire "A2"
    fire "A2"
    fire "A3"
    fire "A3"
    fire "A4"
    fire "A4"
    fire "A5"
    expect(page).to have_content "sunk"
    fire "A5"
    fire "j1"
    fire "j1"
    fire "d5"
    fire "d5"
    fire "e5"
    fire "e5"
    fire "f5"
    fire "f5"
    fire "g5"
    fire "g5"
    fire "C1"
    fire"C1"
    fire"C2"
    fire"C2"
    fire"C3"
    fire "C3"
    fire "I5"
    fire "I5"
    fire "J5"
    expect(page).to have_content "Congratulations Player 1 wins!"
  end
end
def placev coord
  fill_in "location", with: coord
  select "vertically", :from => "direction"
  click_button 'Place'
end
def placeh coord
  fill_in "location", with: coord
  select "horizontally", :from => "direction"
  click_button 'Place'
end

def fire coord
  fill_in "coordinates", with: coord
  click_button 'Fire'
end