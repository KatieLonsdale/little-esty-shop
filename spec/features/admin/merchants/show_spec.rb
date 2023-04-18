require 'rails_helper'

RSpec.describe '/admin/merchants/:id', type: :feature do
  before(:each) do
    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    visit "/admin/merchants/#{@merch_1.id}"
  end
  describe 'When I visit the amdin merchants show page' do
    it 'Then I see a link to update the merchants information when I click the link then I am taken to a page to edit this merchant' do
      expect(page).to have_content("Antique's by #{@merch_1.name}")
      click_link 'Update Merchant'
      expect(current_path).to eq(edit_admin_merchant_path(@merch_1.id))
      expect(page).to have_field('merchant_name', with: "#{@merch_1.name}")
      fill_in('merchant_name', with: 'Boston')
      click_button 'Update Merchant'
      expect(current_path).to eq(admin_merchant_path(@merch_1.id))
      expect(page).to have_content("Boston")
    end
  end
end