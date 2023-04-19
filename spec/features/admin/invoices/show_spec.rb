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
end
