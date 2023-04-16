require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe '/admin', type: :feature do
  before(:each) do
    visit '/admin'
  end

  describe 'when I visit the admin dashboard page' do
    describe 'User Story 19' do
      it 'I see a header indicating that I am on the admin dashboard' do
        expect(page).to have_content('Admin Dashboard')
      end
    end

    describe 'User Story 20' do
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
    end

    describe 'User Story 21' do
      before(:all) do
        delete_data

        us_3_test_data
      end

      it 'Then I see the names of the top 5 customers with the largest number of successful transactions' do
        expect(page).to have_content('Top Customers')

        expect(page).to have_content("#{@cust_6.full_name} - #{@cust_6.success_count} purchases")
        expect(page).to have_content("#{@cust_2.full_name} - #{@cust_2.success_count} purchases")
        expect(page).to have_content("#{@cust_3.full_name} - #{@cust_3.success_count} purchases")
        expect(page).to have_content("#{@cust_4.full_name} - #{@cust_4.success_count} purchases")
        expect(page).to have_content("#{@cust_5.full_name} - #{@cust_5.success_count} purchases")
        expect(page).to_not have_content("#{@cust_1.full_name} - #{@cust_1.success_count} purchases")
      end
    end

    describe 'User Story 22' do
      before(:all) do
        delete_data

        @cust_1 = create(:customer)
        @invoice_1 = create(:invoice, status: 0, customer: @cust_1)
        @invoice_2 = create(:invoice, status: 1, customer: @cust_1)
        @invoice_3 = create(:invoice, status: 2, customer: @cust_1)
        @invoice_4 = create(:invoice, status: 0, customer: @cust_1)
        @invoice_5 = create(:invoice, status: 0, customer: @cust_1)
        @invoice_6 = create(:invoice, status: 1, customer: @cust_1)
        @invoice_7 = create(:invoice, status: 0, customer: @cust_1)
      end

      it "Then I see a section for 'Incomplete Invoices' with a list of the ids of all unshipped invoices with links" do
        expect(page).to have_content('Incomplete Invoices')
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Invoice ##{@invoice_4.id}")
        expect(page).to have_content("Invoice ##{@invoice_5.id}")
        expect(page).to have_content("Invoice ##{@invoice_7.id}")
        expect(page).to_not have_content("Invoice ##{@invoice_2.id}")
        expect(page).to_not have_content("Invoice ##{@invoice_3.id}")
        expect(page).to_not have_content("Invoice ##{@invoice_6.id}")
      end
    end

    describe 'User Story 23' do
      before(:all) do
        delete_data

        @cust_1 = create(:customer)
        @invoice_1 = create(:invoice, status: 0, created_at: 1.month.ago, customer: @cust_1)
        @invoice_4 = create(:invoice, status: 0, created_at: 10.days.ago, customer: @cust_1)
        @invoice_5 = create(:invoice, status: 0, created_at: 2.days.ago, customer: @cust_1)
        @invoice_7 = create(:invoice, status: 0, created_at: Time.now, customer: @cust_1)
      end

      it "Next to each invoice id I see the invoice creation date formatted like 'Monday, July 18, 2019'" do
        expect(page).to have_content("Invoice ##{@invoice_1.id} - #{@invoice_1.created_day_mdy}")
        expect(page).to have_content("Invoice ##{@invoice_4.id} - #{@invoice_4.created_day_mdy}")
        expect(page).to have_content("Invoice ##{@invoice_5.id} - #{@invoice_5.created_day_mdy}")
        expect(page).to have_content("Invoice ##{@invoice_7.id} - #{@invoice_7.created_day_mdy}")
      end

      it 'And I see that the incomplete invoices list is ordered from oldest to newest' do
        expect("Invoice ##{@invoice_1.id}").to appear_before("Invoice ##{@invoice_4.id}")
        expect("Invoice ##{@invoice_4.id}").to appear_before("Invoice ##{@invoice_5.id}")
        expect("Invoice ##{@invoice_5.id}").to appear_before("Invoice ##{@invoice_7.id}")
      end
    end
  end
end
