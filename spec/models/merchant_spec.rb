require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe Merchant do
  before(:all) do
    delete_data
    @merch1 = create(:merchant, status: 0) # enable
    @merch2 = create(:merchant, status: 1) # disable
    @merch3 = create(:merchant, status: 1) # disable
    @merch4 = create(:merchant, status: 0) # disable
    @merch5 = create(:merchant, status: 1) # disable
    @merch6 = create(:merchant, status: 0) # disable

    @item1 = create(:item, merchant: @merch1)
    @item2 = create(:item, merchant: @merch2)
    @item3 = create(:item, merchant: @merch3)
    @item4 = create(:item, merchant: @merch4)
    @item5 = create(:item, merchant: @merch5)
    @item6 = create(:item, merchant: @merch6)

    @invoice1 = create(:invoice)
    @invoice2 = create(:invoice)
    @invoice3 = create(:invoice)

    @invoiceitem1 = create(:invoice_item, invoice: @invoice1, item: @item1, quantity: 100, unit_price: 1000)
    @invoiceitem2 = create(:invoice_item, invoice: @invoice1, item: @item2, quantity: 90, unit_price: 1000)
    @invoiceitem3 = create(:invoice_item, invoice: @invoice1, item: @item3, quantity: 40, unit_price: 1000)
    @invoiceitem4 = create(:invoice_item, invoice: @invoice2, item: @item4, quantity: 90, unit_price: 1000)
    @invoiceitem5 = create(:invoice_item, invoice: @invoice2, item: @item5, quantity: 50, unit_price: 1000)
    @invoiceitem6 = create(:invoice_item, invoice: @invoice2, item: @item6, quantity: 90, unit_price: 1000)
    @invoiceitem7 = create(:invoice_item, invoice: @invoice3, item: @item1, quantity: 90, unit_price: 1000)
    @invoiceitem8 = create(:invoice_item, invoice: @invoice3, item: @item2, quantity: 20, unit_price: 1000)
    @invoiceitem9 = create(:invoice_item, invoice: @invoice3, item: @item3, quantity: 10, unit_price: 1000)
    @invoiceitem10 = create(:invoice_item, invoice: @invoice3, item: @item4, quantity: 5, unit_price: 1000)
    @invoiceitem11 = create(:invoice_item, invoice: @invoice3, item: @item5, quantity: 30, unit_price: 1000)
    @invoiceitem12 = create(:invoice_item, invoice: @invoice3, item: @item6, quantity: 70, unit_price: 1000)

    @transaction1 = create(:transaction, invoice: @invoice1, result: 1)
    @transaction2 = create(:transaction, invoice: @invoice2, result: 1)
    @transaction3 = create(:transaction, invoice: @invoice3, result: 1)
  end
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'enum' do
    it 'defines status as enum' do
      should define_enum_for(:status).
        with_values(disabled: 0, enabled: 1)
    end
  end

  describe '#instance methods' do
    describe '#favorite_customers' do
      before(:each) do
        us_3_test_data
      end
      it 'returns an array of top five customers with most purchases' do
        expect(@merch_1.favorite_customers).to eq([@cust_6, @cust_2, @cust_3, @cust_4, @cust_5])
      end
    end
    describe '#items_ready' do
      before(:each) do
        us_4_test_data
      end
      it 'returns array of invoice_items that are not shipped ordered by invoice age(oldest to newest)' do
        expected = [@pending_item_1, @pending_item_2, @packaged_item_2, @packaged_item_1].flatten
        expect(@merch_1.items_ready).to eq(expected)
      end
    end
    describe '#unique_invoices' do
      it 'returns an array of unique invoices with an item that belong to merchant' do
        us_14_test_data
        expect(@merch_1.unique_invoices.sort).to eq([@invoice_1, @invoice_2])
        expect(@merch_2.unique_invoices.sort).to eq([@invoice_2, @invoice_3])
      end
    end

    describe "#items_on_invoice" do
      it "returns all items found on given invoice for given merchant" do
        us_16_test_data
        expected = [@invoice_item_1, @invoice_item_2]
        results = @merch_1.items_on_invoice(@invoice_1).sort_by{|ii| ii.id}
        expect(results).to eq(expected)
      end
    end
    
    describe '#opposite_status' do 
      it 'returns the opposite status' do
        merchant1 = create(:merchant, status: 0)
        merchant2 = create(:merchant, status: 1)

        expect(merchant1.opposite_status).to eq('Enable')
        expect(merchant2.opposite_status).to eq('Disable')
      end
    end

    describe "#total_revenue" do
      it 'returns the revenue for a given invoice' do
        us_16_test_data
        expect(@merch_1.total_revenue(@invoice_1)).to eq(3947)
        expect(@merch_2.total_revenue(@invoice_1)).to eq(5899)
      end
    end
  end

  describe 'class methods' do
    describe '.top_five_merch_by_revenue' do
      it 'returns the top five merchants with the highest total revenue' do
        expect(Merchant.top_five_merch_by_revenue.to_a).to eq([@merch1, @merch6, @merch2, @merch4, @merch5])
      end
    end
  end
end
