# As a merchant
# When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)
# Then I see information related to that invoice including:

# Invoice id
# Invoice status
# Invoice created_at date in the format "Monday, July 18, 2019"
# Customer first and last name

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
end