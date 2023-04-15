require 'rails_helper'

RSpec.describe '/admin/merchants', type: :feature do
  before(:each) do
    delete_data
    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)
    @merch_3 = create(:merchant)

    visit '/admin/merchants'
  end

  describe 'When I visit the admin merchants index ' do
    it 'I see the name of each merchant in the system' do
      expect(page).to have_content(@merch_1.name)
      expect(page).to have_content(@merch_2.name)
      expect(page).to have_content(@merch_3.name)
    end

    it 'I click on the name of a merchant then I am taken to that merchants admin show page ' do
      click_link "#{@merch_1.name}"
      expect(current_path).to eq(admin_merchant_path(@merch_1))
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