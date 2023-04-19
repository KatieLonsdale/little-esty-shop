require 'rails_helper'
require './spec/testable.rb'
include Testable

RSpec.describe '/admin/invoices index page', type: :feature do
  describe 'User Story 32' do
    before(:all) do
      delete_data
      @cust1 = create(:customer)
      create_list(:invoice, 10, customer: @cust1)
      @invoice_ids = Invoice.pluck(:id)
    end

    it 'displays the subheader' do
      visit admin_invoices_path
      expect(page).to have_content('Invoices')
    end

    it 'list of all invoice ids in the system with links to show page' do
      @invoice_ids.each do |ii|
        visit admin_invoices_path
        expect(page).to have_content("Invoice ##{ii}")
        click_link(ii.to_s)
        expect(current_path).to eq("/admin/invoices/#{ii}")
      end
    end
  end
end
