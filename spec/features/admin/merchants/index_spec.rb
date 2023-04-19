require 'rails_helper'

RSpec.describe '/admin/merchants', type: :feature do
  before(:each) do
    delete_data
    @merch_1 = create(:merchant, status: 0) # enable
    @merch_2 = create(:merchant, status: 1) # disable
    @merch_3 = create(:merchant, status: 1) # disable
    @merch_4 = create(:merchant, status: 0) # disable
    @merch_5 = create(:merchant, status: 1) # disable
    @merch_6 = create(:merchant, status: 0) # disable

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_2)
    @item_3 = create(:item, merchant: @merch_3)
    @item_4 = create(:item, merchant: @merch_4)
    @item_5 = create(:item, merchant: @merch_5)
    @item_6 = create(:item, merchant: @merch_6)

    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)
    @invoice_3 = create(:invoice)

    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 100, unit_price: 1000)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 90, unit_price: 1000)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 40, unit_price: 1000)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 90, unit_price: 1000)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 50, unit_price: 1000)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 90, unit_price: 1000)
    @invoice_item_7 = create(:invoice_item, invoice: @invoice_3, item: @item_1, quantity: 90, unit_price: 1000)
    @invoice_item_8 = create(:invoice_item, invoice: @invoice_3, item: @item_2, quantity: 20, unit_price: 1000)
    @invoice_item_9 = create(:invoice_item, invoice: @invoice_3, item: @item_3, quantity: 10, unit_price: 1000)
    @invoice_item_10 = create(:invoice_item, invoice: @invoice_3, item: @item_4, quantity: 5, unit_price: 1000)
    @invoice_item_11 = create(:invoice_item, invoice: @invoice_3, item: @item_5, quantity: 30, unit_price: 1000)
    @invoice_item_12 = create(:invoice_item, invoice: @invoice_3, item: @item_6, quantity: 70, unit_price: 1000)

    @transaction1 = create(:transaction, invoice: @invoice_1, result: 1)
    @transaction2 = create(:transaction, invoice: @invoice_2, result: 1)
    @transaction3 = create(:transaction, invoice: @invoice_3, result: 1)

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

    describe 'User Story 30' do
      it ' I see the names of the top 5 merchants by total revenue generated' do
        expect(page).to have_content("Top Merchants")
        
        within("#top-merchants") do
          expect(page).to have_content("#{@merch_1.name} - $1900.00 in sales")
          expect(page).to have_content("#{@merch_6.name} - $1600.00 in sales")
          expect(page).to have_content("#{@merch_2.name} - $1100.00 in sales")
          expect(page).to have_content("#{@merch_4.name} - $950.00 in sales")
          expect(page).to have_content("#{@merch_5.name} - $800.00 in sales")

          expect(page).to_not have_content(@merch_3.name)
        end
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