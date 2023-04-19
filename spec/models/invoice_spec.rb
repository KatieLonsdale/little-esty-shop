require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many(:transactions).dependent(:destroy) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'enum' do
    it 'defines status as enum' do
      should define_enum_for(:status).
        with_values("in progress" => 0, completed: 1, cancelled: 2)
    end
  end

  describe 'class methods' do
    describe '.in_progress' do
      it 'returns all invoices in progress' do
        delete_data

        cust_1 = create(:customer)
        invoice_1 = create(:invoice, status: 0, customer: cust_1)
        invoice_2 = create(:invoice, status: 1, customer: cust_1)
        invoice_3 = create(:invoice, status: 2, customer: cust_1)
        invoice_4 = create(:invoice, status: 0, customer: cust_1)
        invoice_5 = create(:invoice, status: 0, customer: cust_1)
        invoice_6 = create(:invoice, status: 1, customer: cust_1)
        invoice_7 = create(:invoice, status: 0, customer: cust_1)

        expect(Invoice.in_progress).to eq([invoice_1, invoice_4, invoice_5, invoice_7])
      end
    end
  end
  describe 'instance methods' do
    describe '#created_day_mdy' do
      it "returns the created date in the format 'Saturday, April 15, 2023'" do
        delete_data

        cust_1 = create(:customer)
        invoice_1 = create(:invoice, status: 0, customer: cust_1)
        invoice_1.created_at = 'Sat, 15 Apr 2023 20:00:32'

        expect(invoice_1.created_day_mdy).to eq('Saturday, April 15, 2023')
      end
    end

    describe 'total revenue' do
      before(:all) do
        delete_data

        item1 = create(:item)
        item2 = create(:item)
        item3 = create(:item)

        @invoice1 = create(:invoice)
        invoice2 = create(:invoice)

        create(:invoice_item, item: item1, invoice: @invoice1, quantity: 1, unit_price: 935)
        create(:invoice_item, item: item2, invoice: @invoice1, quantity: 1, unit_price: 1245)
        create(:invoice_item, item: item3, invoice: invoice2, quantity: 6, unit_price: 30)
      end

      it 'returns the total revenue on the invoice' do
        expect(@invoice1.total_revenue).to eq(2180)
      end
    end
  end
end
