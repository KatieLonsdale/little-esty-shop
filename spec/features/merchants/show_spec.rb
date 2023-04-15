require 'rails_helper'

RSpec.describe 'merchant show page' do
  describe 'as a merchant when I visit my dashboard' do
    before(:all) do
      Merchant.destroy_all
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
    end
    it 'displays the name of merchant' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      expect(page).to have_content(@merch_1.name)
      expect(page).to have_no_content(@merch_2.name)
    end

    it 'displays a link to merchant items index' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#my-items") do
       expect(page).to have_link('My Items')

       click_link('My Items')
      end
       expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
    end

    it 'displays a link to merchant invoices index' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#my-invoices") do
       expect(page).to have_link('My Invoices')

       click_link('My Invoices')
      end
       expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices")
    end
  end
    
  describe 'as merchant when I visit the favorite_customer section of the dashboard' do
    before(:all) do
      us_3_test_data
    end
    it 'displays the names of top five customers based on successful transactions' do
      visit "/merchants/#{@merch_1.id}/dashboard"

      expect(page).to have_content(@cust_6.first_name)
      expect(page).to have_content(@cust_6.last_name)
      expect(page).to have_content(@cust_2.first_name)
      expect(page).to have_content(@cust_2.last_name)
      expect(page).to have_content(@cust_3.first_name)
      expect(page).to have_content(@cust_3.last_name)
      expect(page).to have_content(@cust_4.first_name)
      expect(page).to have_content(@cust_4.last_name)
      expect(page).to have_content(@cust_5.first_name)
      expect(page).to have_content(@cust_5.last_name)
      expect(page).to have_no_content(@cust_1.first_name)
      expect(page).to have_no_content(@cust_1.last_name)

      expect(@cust_6.last_name).to appear_before(@cust_2.last_name)
      expect(@cust_2.last_name).to appear_before(@cust_3.last_name)
      expect(@cust_3.last_name).to appear_before(@cust_4.last_name)
      expect(@cust_4.last_name).to appear_before(@cust_5.last_name)
    end

    it 'displays the number of successful transactions next to the customer name' do
      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#customer-#{@cust_6.id}") do
        expect(page).to have_content("6")
      end

      within("#customer-#{@cust_2.id}") do
        expect(page).to have_content("5")
      end
    end

    it 'does not count failed transactions' do
      visit "/merchants/#{@merch_1.id}/dashboard"
      within("#customer-#{@cust_5.id}") do
        expect(page).to have_content("2")
      end
    end
  end

  describe 'as merchant when I visit the items ready to ship section of the dashboard' do
    it 'shows me my items that have been ordered but not shipped' do
      us_4_test_data
      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_no_content(@item_3.name)
        expect(page).to have_no_content(@item_4.name)
      end
    end

    it 'shows me the invoice id next to each item' do
      us_4_test_data
      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_content(@pending_item_1.first.invoice.id)
        expect(page).to have_content(@pending_item_1.last.invoice.id)
      end
    end

    it 'has the invoice show page linked to each invoice id' do
      Merchant.destroy_all
      Customer.destroy_all
      Invoice.destroy_all
      Item.destroy_all
      InvoiceItem.destroy_all
      @merch_1 = create(:merchant)

      @item_1 = create(:item, merchant: @merch_1)
      @item_2 = create(:item, merchant: @merch_1)

      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)

      @invoice_item = create(:invoice_item, item: @item_1, invoice: @invoice_1, status: 0)

      visit "/merchants/#{@merch_1.id}/dashboard"

      within("#ready-to-ship") do
        expect(page).to have_link("##{@invoice_1.id}", exact_text: true)
      end

      within("#invoice-item-#{@invoice_item.id}") do
        click_link("#{@invoice_1.id}")
      end

      expect(current_path).to eq("/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}")
    end
  end
end

def us_3_test_data
  Merchant.destroy_all
  Customer.destroy_all
  @merch_1 = create(:merchant)
  @merch_2 = create(:merchant)

  @cust_1 = create(:customer)
  @cust_2 = create(:customer)
  @cust_3 = create(:customer)
  @cust_4 = create(:customer)
  @cust_5 = create(:customer)
  @cust_6 = create(:customer)
  @cust_7 = create(:customer)

  @item_1 = create(:item, merchant: @merch_1)
  @item_2 = create(:item, merchant: @merch_2)

  # customer 6 - 6 succ transactions
  # switching cust 6 and 1 to make sure method is able to order on its own
  6.times do
    invoice = create(:invoice, status: 1, customer: @cust_6)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 1, invoice: invoice)
  end

  invoice = create(:invoice, status: 1, customer: @cust_6)
    create(:invoice_item, invoice: invoice, item: @item_2)
    create(:transaction, result: 1, invoice: invoice)

  # customer 2 - 5 succ transactions
  5.times do
    invoice = create(:invoice, status: 1, customer: @cust_2)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 1, invoice: invoice)
  end

  # customer 3 - 4 succ transactions
  4.times do
    invoice = create(:invoice, status: 1, customer: @cust_3)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 1, invoice: invoice)
  end

  # customer 4 - 3 succ transactions
  3.times do
    invoice = create(:invoice, status: 1, customer: @cust_4)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 1, invoice: invoice)
  end
  
  # customer 5 - 2 success 2 failures
  2.times do 
    invoice = create(:invoice, status: 1, customer: @cust_5)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 0, invoice: invoice)
    create(:transaction, result: 1, invoice: invoice)
  end

  # customer 1 - one succ transaction
  invoice = create(:invoice, status: 1, customer: @cust_1)
  create(:invoice_item, invoice: invoice, item: @item_1)
  create(:transaction, result: 1, invoice: invoice)
end

def us_4_test_data
  Merchant.destroy_all
  Customer.destroy_all
  Invoice.destroy_all
  Item.destroy_all
  InvoiceItem.destroy_all
  @merch_1 = create(:merchant)
  @merch_2 = create(:merchant)

  @item_1 = create(:item, merchant: @merch_1)
  @item_2 = create(:item, merchant: @merch_1)
  @item_3 = create(:item, merchant: @merch_1)
  @item_4 = create(:item, merchant: @merch_2)

  @invoice_1 = create(:invoice)
  @invoice_2 = create(:invoice)
  @invoice_3 = create(:invoice)

  # pending invoice_items - 5 - should appear
  @pending_item_1 = create_list(:invoice_item, 2, item: @item_1, invoice: @invoice_1, status: 0)
  @pending_item_2 = create_list(:invoice_item, 3, item: @item_2, invoice: @invoice_2, status: 0)

  # packaged invoice_items - 6 - should appear
  @packaged_item_1 = create_list(:invoice_item, 2, item: @item_1, invoice: @invoice_3, status: 1)
  @packaged_item_2 = create_list(:invoice_item, 4, item: @item_2, invoice: @invoice_2, status: 1)

  # shipped invoice_items - 2 - should not appear
  create(:invoice_item, item: @item_1, invoice: @invoice_1, status: 2)
  create(:invoice_item, item: @item_3, invoice: @invoice_2, status: 2)

  # other merchant item - should not appear
  create(:invoice_item, item: @item_4, invoice: @invoice_2, status: 0)

end

# As a merchant
# When I visit my merchant dashboard
# Then I see a section for "Items Ready to Ship"
# In that section I see a list of the names of all of my items that
# have been ordered and have not yet been shipped,
# And next to each Item I see the id of the invoice that ordered my item
# And each invoice id is a link to my merchant's invoice show page