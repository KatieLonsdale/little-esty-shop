require 'rails_helper'

RSpec.describe '/admin/merchants/:id/edit', type: :feature do
  before(:each) do
    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    visit "/admin/merchants/#{@merch_1.id}/edit"
  end

  describe 'Admin merchant edit page' do
    it 'displays Edit form' do
      expect(page).to have_field('merchant_name', with: "#{@merch_1.name}")
      fill_in('merchant_name', with: 'Boston')
      click_button 'Update Merchant'
      expect(current_path).to eq(admin_merchant_path(@merch_1.id))
      expect(page).to have_content("Boston")
    end
  end
end
