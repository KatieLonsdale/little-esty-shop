
require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant items new page' do
  before(:all) do
    delete_data
    @merch_2 = create(:merchant)
    visit "/merchants/#{@merch_2.id}/items/new" 
  end
  describe 'when I visit my my items new page' do
    it 'displays a form where I can add new item and item info' do

      within("#new-item-info") do  

        fill_in('name', with: 'ceramic watering can')
        fill_in('description', with: 'heavy and impractical')
        fill_in('unit_price', with: 49)
 
        click_on("Submit")
      end

      expect(current_path).to eq("/merchants/#{@merch_2.id}/items")
      expect(page).to have_content('ceramic watering can')
    end
  end
end