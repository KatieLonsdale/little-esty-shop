require 'rails_helper'

RSpec.describe '/admin', type: :feature do
  before(:each) do
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
