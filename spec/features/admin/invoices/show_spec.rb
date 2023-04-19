require 'rails_helper'
require './spec/testable.rb'
include Testable

RSpec.describe '/admin/invoices show page', type: :feature do
  describe 'User Story 33' do
    before(:all) do
      delete_data
      @cust1 = create(:customer)
      @invoice1 = create(:invoice, customer: @cust1)
      visit admin_invoice_path(@invoice1)
    end

    it 'displays the subheader and lists invoice details' do
      expect(page).to have_content("Invoice ##{@invoice1.id}")
      expect(page).to have_content("Status: #{@invoice1.status}")
      expect(page).to have_content("Created on: #{@invoice1.created_day_mdy}")
      expect(page).to have_content('Customer:')
      expect(page).to have_content(@invoice1.customer.full_name)
    end
  end

  describe 'User Story 35' do
    before(:all) do
      delete_data

      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)

      @invoice1 = create(:invoice)
      invoice2 = create(:invoice)

      create(:invoice_item, item: item1, invoice: @invoice1, quantity: 1, unit_price: 935)
      create(:invoice_item, item: item2, invoice: @invoice1, quantity: 1, unit_price: 1245)
      create(:invoice_item, item: item3, invoice: invoice2, quantity: 6, unit_price: 30)

      visit admin_invoice_path(@invoice1)
    end

    it 'displays the total revenue' do
      expect(page).to have_content("Total Revenue: $#{format('%.2f', @invoice1.total_revenue)}")
      save_and_open_page
    end
  end
end
