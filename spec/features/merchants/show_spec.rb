require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant show page' do
  describe 'as a merchant when I visit my dashboard' do
    before(:all) do
      delete_data
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
    end
    it 'displays the name of merchant' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      expect(page).to have_content(@merch_1.name)
      expect(page).to have_no_content(@merch_2.name)
    end

    it 'displays a link to merchant items index' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#my-items") do
       expect(page).to have_link('My Items')

       click_link('My Items')
      end
       expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
    end

    it 'displays a link to merchant invoices index' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#my-invoices") do
       expect(page).to have_link('My Invoices')

       click_link('My Invoices')
      end
       expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices")
    end
  end
    
  describe 'as merchant when I visit the favorite_customer section of the dashboard' do
    before(:all) do
      us_3_test_data
    end
    it 'displays the names of top five customers based on successful transactions' do
      visit "/merchants/#{@merch_1.id}/dashboard"

      expect(page).to have_content(@cust_6.first_name)
      expect(page).to have_content(@cust_6.last_name)
      expect(page).to have_content(@cust_2.first_name)
      expect(page).to have_content(@cust_2.last_name)
      expect(page).to have_content(@cust_3.first_name)
      expect(page).to have_content(@cust_3.last_name)
      expect(page).to have_content(@cust_4.first_name)
      expect(page).to have_content(@cust_4.last_name)
      expect(page).to have_content(@cust_5.first_name)
      expect(page).to have_content(@cust_5.last_name)
      expect(page).to have_no_content(@cust_1.first_name)
      expect(page).to have_no_content(@cust_1.last_name)

      expect(@cust_6.last_name).to appear_before(@cust_2.last_name)
      expect(@cust_2.last_name).to appear_before(@cust_3.last_name)
      expect(@cust_3.last_name).to appear_before(@cust_4.last_name)
      expect(@cust_4.last_name).to appear_before(@cust_5.last_name)
    end

    it 'displays the number of successful transactions next to the customer name' do
      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#customer-#{@cust_6.id}") do
        expect(page).to have_content("6")
      end

      within("#customer-#{@cust_2.id}") do
        expect(page).to have_content("5")
      end
    end

    it 'does not count failed transactions' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#customer-#{@cust_5.id}") do
        expect(page).to have_content("2")
      end
    end
  end

  describe 'as merchant when I visit the items ready to ship section of the dashboard' do
    it 'shows me my items that have been ordered but not shipped' do
      us_4_test_data

      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_no_content(@item_3.name)
        expect(page).to have_no_content(@item_4.name)
      end
    end

    it 'shows me the invoice id next to each item' do
      us_4_test_data
      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_content(@pending_item_1.first.invoice.id)
        expect(page).to have_content(@pending_item_1.last.invoice.id)
      end
    end

    it 'has the invoice show page linked to each invoice id' do
      delete_data

      @merch_1 = create(:merchant)

      @item_1 = create(:item, merchant: @merch_1)
      @item_2 = create(:item, merchant: @merch_1)

      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)

      @invoice_item = create(:invoice_item, item: @item_1, invoice: @invoice_1, status: 0)

      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_link("##{@invoice_1.id}", exact_text: true)
      end

      within("#invoice-item-#{@invoice_item.id}") do
        click_link("#{@invoice_1.id}")
      end

      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}")
    end
    it 'has the date the invoice was created next to each item' do
      us_5_test_data
      current_date = DateTime.now.strftime("%A, %B %d, %Y")

      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#invoice-item-#{@invoice_item_1.id}") do
        expect(page).to have_content("#{current_date}")
      end

      within("#invoice-item-#{@invoice_item_1.id}") do
        expect(page).to have_content("#{current_date}")
      end

    end
    xit 'is ordered from oldest to newest' do

    end
  end
end


# And I see the date formatted like "Monday, July 18, 2019"
# And I see that the list is ordered from oldest to newest