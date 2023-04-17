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

    describe '#opposite_status' do 
      it 'returns the opposite status' do
        merchant1 = create(:merchant, status: 0)
        merchant2 = create(:merchant, status: 1)

        expect(merchant1.opposite_status).to eq('Enable')
        expect(merchant2.opposite_status).to eq('Disable')
      end
    end
  end
end
