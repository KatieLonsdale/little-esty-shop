require 'rails_helper'

RSpec.describe '/admin/merchants/new', type: :feature do
  before(:each) do
    visit '/admin/merchants'
    click_link 'New Merchant'
  end
  describe 'when I am taken to the admin merchants new page' do
    describe 'User Story 29' do
      it 'I fill out the form I click ‘Submit’ I see the merchant I just created displayed And I see my merchant was created with a default status of disabled.' do
        expect(current_path).to eq(new_admin_merchant_path)
        expect(page).to have_field('name')

        fill_in('name', with: 'Lowrey')
        click_button('Submit')
        expect(current_path).to eq(admin_merchants_path)
        expect(page).to have_content('Lowrey')
      end
    end
  end
end