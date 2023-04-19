require 'rails_helper'

RSpec.describe '/admin/merchants', type: :feature do
  before(:each) do
    delete_data
    @merch_1 = create(:merchant, status: 0) # enable
    @merch_2 = create(:merchant, status: 1) # disable
    @merch_3 = create(:merchant, status: 1) # disable

    visit '/admin/merchants'
  end

  describe 'When I visit the admin merchants index ' do
    describe 'User Story 24' do
      it 'I see the name of each merchant in the system' do
        expect(page).to have_content(@merch_1.name)
        expect(page).to have_content(@merch_2.name)
        expect(page).to have_content(@merch_3.name)
      end
    end

    describe 'User Story 25' do
      it 'I click on the name of a merchant then I am taken to that merchants admin show page ' do
        click_link "#{@merch_1.name}"
        expect(current_path).to eq(admin_merchant_path(@merch_1))
      end
    end

    describe 'User Story 27' do
      it 'Then I see a button to disable/enable for each merchant' do
        within("#merchant-#{@merch_1.id}") do
          expect(page).to have_button('Enable')
        end

        within("#merchant-#{@merch_2.id}") do
          expect(page).to have_button('Disable')
        end

        within("#merchant-#{@merch_3.id}") do
          expect(page).to have_button('Disable')
        end
      end

      it 'When I clicked enable I am redirected to the admin merchants index and status is changed to disabled' do
        within("#merchant-#{@merch_1.id}") do
          expect(page).to have_button('Enable')
          click_button('Enable')
        end

        expect(current_path).to eq('/admin/merchants')

        within("#merchant-#{@merch_1.id}") do
          expect(page).to have_button('Disable')
        end
      end

      it 'When I clicked disable I am redirected to the admin merchants index and status is changed to enabled' do
        within("#merchant-#{@merch_2.id}") do
          expect(page).to have_button('Disable')
          click_button('Disable')
        end

        expect(current_path).to eq('/admin/merchants')
        within("#merchant-#{@merch_2.id}") do
          expect(page).to have_button('Enable')
        end
      end
    end

    describe 'User Story 28' do
      it 'I see two sections for each of "Enabled/Disabled Merchants" and merchants listed accordingly' do
        within("#enabled-merchants") do
          expect(page).to have_content("Enabled Merchants")
          expect(page).to_not have_content(@merch_1.name)
          expect(page).to have_content(@merch_2.name)
          expect(page).to have_content(@merch_3.name)
        end

        within("#disabled-merchants") do
          expect(page).to have_content("Disabled Merchants")
          expect(page).to have_content(@merch_1.name)
          expect(page).to_not have_content(@merch_2.name)
          expect(page).to_not have_content(@merch_3.name)
        end
      end
    end

    describe 'User Story 29' do
      it 'I see a link to create a new merchant' do
        expect(page).to have_link('New Merchant')
        click_link 'New Merchant'
        expect(current_path).to eq(new_admin_merchant_path)
      end
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