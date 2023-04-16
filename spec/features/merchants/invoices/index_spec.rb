require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant invoices index' do
  describe "As a merchant, when I visit my merchant's invoices index" do
    before(:all) do
      us_14_test_data
    end
    it 'displays all invoices that include at least one of my items and their id' do
      visit "/merchants/#{@merch_1.id}/invoices"

      within("#my-invoices-list") do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Invoice ##{@invoice_2.id}")
        expect(page).to have_no_content("Invoice ##{@invoice_3.id}")
      end
    end

    it 'links the invoice show page to its id' do
      visit "/merchants/#{@merch_1.id}/invoices"

      within("#invoice-#{@invoice_1.id}") do
        expect(page).to have_link("##{@invoice_1.id}")
        click_link("##{@invoice_1.id}")
      end
      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}")
    end
  end
end