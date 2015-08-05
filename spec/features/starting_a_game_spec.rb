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
  end
  scenario 'Gives default name if none submitted' do
    visit '/name_set'
    click_button 'Submit'
    expect(page).to have_content "Hello, Player 1"
  end
  scenario "I can choose to start a game against a computer" do
    visit '/name_set'
    click_button 'Submit'
    click_link "VS Computer"
    expect(page).to have_content "Enter coordinates to fire upon"
  end
  scenario "I can start a game against a human opponent" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    expect(page).to have_content "What is player 2's name?"
    our_name="Josh"
    fill_in "name", with: our_name
    click_button 'Submit'
    expect(page).to have_content "Player 1 VS #{our_name}"
  end
end
feature 'Playing against computer' do
  scenario 'I can enter coordinates' do
    visit '/play'
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    expect(page).to have_content "hit"
    fill_in "coordinates", with: "I7"
    click_button 'Fire'
    expect(page).to have_content "miss"
  end
  scenario 'I can win' do
    visit '/play'
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    fill_in "coordinates", with: "B1"
    click_button 'Fire'
    fill_in "coordinates", with: "C1"
    click_button 'Fire'
    expect(page).to have_content "Congratulations. You win!"
  end
  scenario 'I can start a new game after game ended' do
    visit '/play'
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    fill_in "coordinates", with: "B1"
    click_button 'Fire'
    fill_in "coordinates", with: "C1"
    click_button 'Fire'
    expect(page).to have_link "New Game"
    click_link "New Game"
    expect(page).to have_content "Are you ready to play Battleships?"
  end
end
feature 'Playing against human opponent' do
  scenario 'Player 1 can place ships' do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    click_button 'Submit'
    expect(page).to have_content "Player 1 please select ship locations."
    expect(page).to have_content "Aircraft Carrier: "
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    expect(page).to have_content "Battleship: "
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    expect(page).to have_content "Cruiser: "
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    expect(page).to have_content "Destroyer: "
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    expect(page).to have_content "Submarine: "
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    expect(page).to have_content "Player 2 please select ship locations."
  end
  scenario 'Player 2 can place ships' do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    click_button 'Submit'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    expect(page).to have_content "Player 2 please select ship locations."
    expect(page).to have_content "Aircraft Carrier: "
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    expect(page).to have_content "Battleship: "
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    expect(page).to have_content "Cruiser: "
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    expect(page).to have_content "Destroyer: "
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    expect(page).to have_content "Submarine: "
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    expect(page).to have_content "Who will fire first?"
  end
  scenario "can select who goes first" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    click_button 'Submit'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    click_link 'Player 2'
    expect(page).to have_content "Player 2's turn"
  end
  scenario "a player can take a turn" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    click_button 'Submit'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    click_link "Player 1"
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    expect(page).to have_content "hit"
    expect(page).to have_content "Player 2's turn"
  end
  scenario "a player can win the game" do
    visit '/name_set'
    click_button 'Submit'
    click_link "PVP"
    click_button 'Submit'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    fill_in "location1", with: "A1"
    select "vertically", :from => "direction1"
    fill_in "location2", with: "D5"
    select "horizontally", :from => "direction2"
    fill_in "location3", with: "C1"
    select "vertically", :from => "direction3"
    fill_in "location4", with: "I5"
    select "horizontally", :from => "direction4"
    fill_in "location5", with: "J1"
    select "horizontally", :from => "direction5"
    click_button 'Place'
    click_link "Player 1"
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    fill_in "coordinates", with: "A1"
    click_button 'Fire'
    fill_in "coordinates", with: "A2"
    click_button 'Fire'
    fill_in "coordinates", with: "A2"
    click_button 'Fire'
    fill_in "coordinates", with: "A3"
    click_button 'Fire'
    fill_in "coordinates", with: "A3"
    click_button 'Fire'
    fill_in "coordinates", with: "A4"
    click_button 'Fire'
    fill_in "coordinates", with: "A4"
    click_button 'Fire'
    fill_in "coordinates", with: "A5"
    click_button "Fire"
    expect(page).to have_content "sunk"
    fill_in "coordinates", with: "A5"
    click_button "Fire"
    fill_in "coordinates", with: "j1"
    click_button 'Fire'
    fill_in "coordinates", with: "j1"
    click_button 'Fire'
    fill_in "coordinates", with: "d5"
    click_button 'Fire'
    fill_in "coordinates", with: "d5"
    click_button 'Fire'
    fill_in "coordinates", with: "e5"
    click_button 'Fire'
    fill_in "coordinates", with: "e5"
    click_button 'Fire'
    fill_in "coordinates", with: "f5"
    click_button 'Fire'
    fill_in "coordinates", with: "f5"
    click_button 'Fire'
    fill_in "coordinates", with: "g5"
    click_button 'Fire'
    fill_in "coordinates", with: "g5"
    click_button 'Fire'
    fill_in "coordinates", with: "C1"
    click_button 'Fire'
    fill_in "coordinates", with: "C1"
    click_button 'Fire'
    fill_in "coordinates", with: "C2"
    click_button 'Fire'
    fill_in "coordinates", with: "C2"
    click_button 'Fire'
    fill_in "coordinates", with: "C3"
    click_button 'Fire'
    fill_in "coordinates", with: "C3"
    click_button 'Fire'
    fill_in "coordinates", with: "I5"
    click_button 'Fire'
    fill_in "coordinates", with: "I5"
    click_button 'Fire'
    fill_in "coordinates", with: "J5"
    click_button 'Fire'
    expect(page).to have_content "Congratulations Player 1 wins!"
  end
end