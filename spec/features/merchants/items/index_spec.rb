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
        list_of_items.each do |item|
          
          expect(page).to have_link "#{item.name}", href: "/merchants/#{@merch_1.id}/items/#{item.id}"
        end
      end

      within("#my-items-list") do
        list_of_items.each do |item|
          visit "merchants/#{@merch_1.id}/items"

         click_link("#{item.name}")

         expect(current_path).to eq("/merchants/#{@merch_1.id}/items/#{item.id}")
        end
      end
    end
  end
  describe "enabled/disabled items section" do
    before(:all) do
      us_9_test_data
      visit "/merchants/#{@merch_1.id}/items"
    end
    it 'has a button next to each item to enable or disable it' do
      within("#item-#{@item_1.id}") do
        expect(page).to have_button('Enable')
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_button('Disable')
      end

      within("#item-#{@item_3.id}") do
        expect(page).to have_button('Disable')
      end
    end

    it 'When I click enable I am returned to the page and status is changed to disabled' do
      visit "/merchants/#{@merch_1.id}/items"
      within("#item-#{@item_1.id}") do
        expect(page).to have_button('Enable')
        click_button('Enable')
      end

      expect(current_path).to eq("/merchants/#{@merch_1.id}/items")

      within("#item-#{@item_1.id}") do
        expect(page).to have_button('Disable')
      end
    end

    it 'When I click disable I am returned to the page and status is changed to enabled' do
      visit "/merchants/#{@merch_1.id}/items"
      within("#item-#{@item_2.id}") do
        expect(page).to have_button('Disable')
        click_button('Disable')
      end

      expect(current_path).to eq("/merchants/#{@merch_1.id}/items")

      within("#item-#{@item_2.id}") do
        expect(page).to have_button('Enable')
      end
    end
  end
end