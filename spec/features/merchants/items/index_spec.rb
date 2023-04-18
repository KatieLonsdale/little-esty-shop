require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant items index page' do
  describe 'when I visit my my items index page' do
    before(:all) do
      delete_data
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
      create_list(:item, 10, merchant_id: @merch_1.id)
      create_list(:item, 3, merchant_id: @merch_2.id)
    end

    it 'displays a list of the names of all my items' do
      visit "/merchants/#{@merch_1.id}/items"
      list_of_names = @merch_1.items.pluck('name')
     
      within("#my-items-list") do
        list_of_names.each do |name|
          expect(page).to have_content(name)
        end
      end
    end
     
    it 'does not display items from other merchants' do
      visit "/merchants/#{@merch_1.id}/items"

      list_of_names_2 = @merch_2.items.pluck('name')

      within("#my-items-list") do
        list_of_names_2.each do |name|
          expect(page).to_not have_content(name)
        end
      end
    end

    it 'links each item to that items show page' do
      #require 'pry'; binding.pry
      visit "merchants/#{@merch_1.id}/items"
      list_of_items = @merch_1.items
      
      within("#my-items-list") do
        save_and_open_page
        list_of_items.each do |item|
          #require 'pry'; binding.pry
          expect(page).to have_link "#{item.name}", href: "/merchants/#{@merch_1.id}/items/#{item.id}"
        end
      end

      within("#my-items-list") do
        list_of_items.each do |item|

         click_link("Item")

         expect(current_path).to eq("/merchants/#{@merch_1.id}/items/#{item.id}")
        end
      end
    end
  end
end