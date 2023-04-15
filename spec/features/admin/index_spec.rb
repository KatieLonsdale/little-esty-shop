require 'rails_helper'

RSpec.describe '/admin', type: :feature do
  before(:all) do
    delete_data
    @cust_1 = create(:customer)
    @cust_2 = create(:customer)
    @cust_3 = create(:customer)
    @cust_4 = create(:customer)
    @cust_5 = create(:customer)
    @cust_6 = create(:customer)
    @invoice_1 = create(:invoice, customer: @cust_1)
    @invoice_2 = create(:invoice, customer: @cust_1)
    @invoice_3 = create(:invoice, customer: @cust_1)
    @invoice_4 = create(:invoice, customer: @cust_1)
    @invoice_5 = create(:invoice, customer: @cust_1)
    @invoice_6 = create(:invoice, customer: @cust_1)
    @invoice_7 = create(:invoice, customer: @cust_2)
    @invoice_8 = create(:invoice, customer: @cust_2)
    @invoice_9 = create(:invoice, customer: @cust_2)
    @invoice_10 = create(:invoice, customer: @cust_2)
    @invoice_11 = create(:invoice, customer: @cust_2)
    @invoice_12 = create(:invoice, customer: @cust_3)
    @invoice_13 = create(:invoice, customer: @cust_3)
    @invoice_14 = create(:invoice, customer: @cust_3)
    @invoice_15 = create(:invoice, customer: @cust_3)
    @invoice_16 = create(:invoice, customer: @cust_4)
    @invoice_17= create(:invoice, customer: @cust_4)
    @invoice_18 = create(:invoice, customer: @cust_4)
    @invoice_19 = create(:invoice, customer: @cust_5)
    @invoice_20= create(:invoice, customer: @cust_5)
    @invoice_21 = create(:invoice, customer: @cust_6)
    @trans_1 = create(:transaction, result: 1, invoice: @invoice_1)
    @trans_2 = create(:transaction, result: 1, invoice: @invoice_2)
    @trans_3 = create(:transaction, result: 1, invoice: @invoice_3)
    @trans_4 = create(:transaction, result: 1, invoice: @invoice_4)
    @trans_5 = create(:transaction, result: 1, invoice: @invoice_5)
    @trans_6 = create(:transaction, result: 1, invoice: @invoice_6)
    @trans_7 = create(:transaction, result: 1, invoice: @invoice_6)
    @trans_8 = create(:transaction, result: 1, invoice: @invoice_8)
    @trans_9 = create(:transaction, result: 1, invoice: @invoice_9)
    @trans_10 = create(:transaction, result: 1, invoice: @invoice_10)
    @trans_11 = create(:transaction, result: 1, invoice: @invoice_11)
    @trans_12 = create(:transaction, result: 1, invoice: @invoice_12)
    @trans_13 = create(:transaction, result: 1, invoice: @invoice_13)
    @trans_14 = create(:transaction, result: 1, invoice: @invoice_14)
    @trans_15 = create(:transaction, result: 1, invoice: @invoice_15)
    @trans_16 = create(:transaction, result: 1, invoice: @invoice_16)
    @trans_17 = create(:transaction, result: 1, invoice: @invoice_17)
    @trans_18 = create(:transaction, result: 1, invoice: @invoice_18)
    @trans_19 = create(:transaction, result: 1, invoice: @invoice_19)
    @trans_20 = create(:transaction, result: 0, invoice: @invoice_20)
    @trans_21 = create(:transaction, result: 1, invoice: @invoice_20)
    @trans_22 = create(:transaction, result: 1, invoice: @invoice_21)
    
    visit '/admin'
  end

  describe 'when I visit the admin dashboard page' do
    it 'I see a header indicating that I am on the admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end

    it 'Then I see a link to the admin merchants index (/admin/merchants)' do
      expect(page).to have_link('Merchants')

      within('div#merchants') do
        click_link 'Merchants'

        expect(current_path).to eq('/admin/merchants')
      end
    end

    it 'Then I see a link to the admin invoices index (/admin/invoices)' do
      expect(page).to have_link('Invoices')

      within('div#invoices') do
        click_link 'Invoices'

        expect(current_path).to eq('/admin/invoices')
      end
    end

    it 'Then I see the names of the top 5 customers with the largest number of successful transactions' do
      expect(page).to have_content("Top Customers")

      expect(page).to have_content("#{@cust_1.full_name} - #{@cust_1.success_count} purchases")
      expect(page).to have_content("#{@cust_2.full_name} - #{@cust_2.success_count} purchases")
      expect(page).to have_content("#{@cust_3.full_name} - #{@cust_3.success_count} purchases")
      expect(page).to have_content("#{@cust_4.full_name} - #{@cust_4.success_count} purchases")
      expect(page).to have_content("#{@cust_5.full_name} - #{@cust_5.success_count} purchases")
    end
  end
end


def delete_data
  Transaction.delete_all
  InvoiceItem.delete_all
  Item.delete_all
  Invoice.delete_all
  Merchant.delete_all
  Customer.delete_all
end