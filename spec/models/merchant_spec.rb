require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
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
        expected = [@invoice_item_1, @invoice_item_2, @invoice_item_3, @invoice_item_4, @invoice_item_5]
        results = @merch_1.items_on_invoice(@invoice_1).sort_by{|ii| ii.id}
        expect(results).to eq(expected)
      end
    end
  end
end