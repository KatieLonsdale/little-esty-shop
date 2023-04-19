require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant items show page' do
  describe 'when I visit my my items show page' do
    before(:all) do
      delete_data
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
      @item_1 = create(:item, merchant: @merch_1)
      @item_2 = create(:item, merchant: @merch_2)
    end

    it 'displays a link to update item information' do
      visit "/merchants/#{@merch_2.id}/items/#{@item_2.id}"
    save_and_open_page
      within("#update-item-info") do
       
        click_link("Update Item")

        expect(current_path).to eq("/merchants/#{@merch_2.id}/items/#{@item_2.id}/edit")
      
        fill_in ('item_description', with 'lovely and useful')
        fill_in ('item_unit_price', with '175')

        click_on "Update Item"

        expect(current_path).to eq("/merchants/#{@merch_2.id}/items/#{@item_2.id}")
        expect(page).to have_content('lovely and useful')
        expect(page).to have_content('175')

      end
    end
  end
end