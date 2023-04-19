require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchants invoice show page' do
  describe "When I visit my merchant's invoice show page" do
    before(:all) do
      us_15_test_data
    end
    it "shows me the invoice id" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#subheader-bar") do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_no_content("Invoice ##{@invoice_2.id}")
      end
    end
    it "shows me the invoice status" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#invoice-info") do
        expect(page).to have_content("Status: #{@invoice_1.status}")
      end
    end
    it "shows me the invoice created date" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#invoice-info") do
        expect(page).to have_content("Created on: #{@invoice_1.created_day_mdy}")
      end
    end
    it "shows me the invoice's customer name" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#customer-info") do
        expect(page).to have_content(@customer_1.full_name)
      end
    end
  end
  describe "When I visit my merchant's invoice show page - invoice item info" do
    before(:all) do
      us_16_test_data
    end
    it "displays all items on the invoice" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#items-on-invoice") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_no_content(@item_3.name)
      end
    end
    it "does not show other merchants' items" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#items-on-invoice") do
        expect(page).to have_no_content(@item_4.name)
      end
    end
    it "shows the quantity ordered of the item" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#item-#{@invoice_item_1.id}") do
        expect(page).to have_content(3)
      end
      within("#item-#{@invoice_item_2.id}") do
        expect(page).to have_content(2)
      end
    end
    it "shows the price the item sold for formatted as price" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#item-#{@invoice_item_1.id}") do
        expect(page).to have_content("$3.49")
      end
      within("#item-#{@invoice_item_2.id}") do
        expect(page).to have_content("$14.50")
      end
    end
    it "shows the status of the items" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#item-#{@invoice_item_1.id}") do
        expect(page).to have_content(@invoice_item_1.status)
      end
      within("#item-#{@invoice_item_2.id}") do
        expect(page).to have_content(@invoice_item_2.status)
      end
    end
    it "shows me  the total revenue from all of my items on the invoice" do
      visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
      within("#invoice-info") do
        expect(page).to have_content("Total Revenue: $39.47")
      end
    end
  end
end

# I see that each invoice item status is a select field
# And I see that the invoice item's current status is selected
# When I click this select field,
# Then I can select a new status for the Item,
# And next to the select field I see a button to "Update Item Status"
# When I click this button
# I am taken back to the merchant invoice show page
# And I see that my Item's status has now been updated