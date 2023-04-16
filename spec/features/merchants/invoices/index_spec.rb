require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe 'merchant invoices index' do
  describe "As a merchant, when I visit my merchant's invoices index" do
    before(:all) do
      us_14_test_data
    end
    it 'displays all invoices that include at least one of my items' do
      visit "/merchants/#{@merch_1.id}/invoices"
      save_and_open_page

      within("#my-invoices-list") do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Invoice ##{@invoice_2.id}")
        expect(page).to have_no_content("Invoice ##{@invoice_3.id}")
      end
    end

    xit 'displays the invoice id next to the invoice which links to its show page' do

    end
  end
end