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
    visit '/'
    click_link 'New Game'
    click_button 'Submit'
    expect(page).to have_content "Hello, Player 1"
  end
  scenario 'Starts a new game' do
    visit '/play'
    expect(page).to have_content "This is your board"
  end
end
feature 'Shooting at opponent board' do
  scenario 'I can enter coordinates' do
    visit '/play'
    our_coordinates="A1"
    fill_in "coordinates", with: our_coordinates
    click_button 'Fire'
    expect(page).to have_content "You have hit an opponent\'s ship"
  end
end
