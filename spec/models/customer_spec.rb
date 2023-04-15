require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe Customer do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:items).through(:invoices) }
  end

  describe 'class methods' do
    it '.top_five_cust' do
      delete_data

      @cust_1 = create(:customer)
      @cust_2 = create(:customer)
      @cust_3 = create(:customer)
      @cust_4 = create(:customer)
      @cust_5 = create(:customer)
      @cust_6 = create(:customer)
      @invoice_1 = create(:invoice, customer: @cust_1)
      @invoice_2 = create(:invoice, customer: @cust_1)
      @invoice_3 = create(:invoice, customer: @cust_1)
      @invoice_4 = create(:invoice, customer: @cust_1)
      @invoice_5 = create(:invoice, customer: @cust_1)
      @invoice_6 = create(:invoice, customer: @cust_1)
      @invoice_7 = create(:invoice, customer: @cust_2)
      @invoice_8 = create(:invoice, customer: @cust_2)
      @invoice_9 = create(:invoice, customer: @cust_2)
      @invoice_10 = create(:invoice, customer: @cust_2)
      @invoice_11 = create(:invoice, customer: @cust_2)
      @invoice_12 = create(:invoice, customer: @cust_3)
      @invoice_13 = create(:invoice, customer: @cust_3)
      @invoice_14 = create(:invoice, customer: @cust_3)
      @invoice_15 = create(:invoice, customer: @cust_3)
      @invoice_16 = create(:invoice, customer: @cust_4)
      @invoice_17= create(:invoice, customer: @cust_4)
      @invoice_18 = create(:invoice, customer: @cust_4)
      @invoice_19 = create(:invoice, customer: @cust_5)
      @invoice_20= create(:invoice, customer: @cust_5)
      @invoice_21 = create(:invoice, customer: @cust_6)
      @trans_1 = create(:transaction, result: 1, invoice: @invoice_1)
      @trans_2 = create(:transaction, result: 1, invoice: @invoice_2)
      @trans_3 = create(:transaction, result: 1, invoice: @invoice_3)
      @trans_4 = create(:transaction, result: 1, invoice: @invoice_4)
      @trans_5 = create(:transaction, result: 1, invoice: @invoice_5)
      @trans_6 = create(:transaction, result: 1, invoice: @invoice_6)
      @trans_7 = create(:transaction, result: 1, invoice: @invoice_6)
      @trans_8 = create(:transaction, result: 1, invoice: @invoice_8)
      @trans_9 = create(:transaction, result: 1, invoice: @invoice_9)
      @trans_10 = create(:transaction, result: 1, invoice: @invoice_10)
      @trans_11 = create(:transaction, result: 1, invoice: @invoice_11)
      @trans_12 = create(:transaction, result: 1, invoice: @invoice_12)
      @trans_13 = create(:transaction, result: 1, invoice: @invoice_13)
      @trans_14 = create(:transaction, result: 1, invoice: @invoice_14)
      @trans_15 = create(:transaction, result: 1, invoice: @invoice_15)
      @trans_16 = create(:transaction, result: 1, invoice: @invoice_16)
      @trans_17 = create(:transaction, result: 1, invoice: @invoice_17)
      @trans_18 = create(:transaction, result: 1, invoice: @invoice_18)
      @trans_19 = create(:transaction, result: 1, invoice: @invoice_19)
      @trans_20 = create(:transaction, result: 0, invoice: @invoice_20)
      @trans_21 = create(:transaction, result: 1, invoice: @invoice_20)
      @trans_22 = create(:transaction, result: 1, invoice: @invoice_21)

      expect(Customer.top_five_cust).to eq([@cust_1, @cust_2, @cust_3, @cust_4, @cust_5])
    end
  end

  describe 'instance methods' do
    describe '#success_count' do
      it 'count of successful transactions for a customer' do
        delete_data

        @cust_1 = create(:customer)
        @cust_5 = create(:customer)
        @invoice_1 = create(:invoice, customer: @cust_1)
        @invoice_4 = create(:invoice, customer: @cust_1)
        @invoice_5 = create(:invoice, customer: @cust_1)
        @invoice_6 = create(:invoice, customer: @cust_1)
        @invoice_19 = create(:invoice, customer: @cust_5)
        @invoice_20= create(:invoice, customer: @cust_5)
        @trans_1 = create(:transaction, result: 1, invoice: @invoice_1)
        @trans_4 = create(:transaction, result: 1, invoice: @invoice_4)
        @trans_5 = create(:transaction, result: 1, invoice: @invoice_5)
        @trans_6 = create(:transaction, result: 1, invoice: @invoice_6)
        @trans_7 = create(:transaction, result: 1, invoice: @invoice_6)
        @trans_19 = create(:transaction, result: 1, invoice: @invoice_19)
        @trans_20 = create(:transaction, result: 0, invoice: @invoice_20)
        @trans_21 = create(:transaction, result: 1, invoice: @invoice_20)

        expect(@cust_1.success_count).to eq(5)
        expect(@cust_5.success_count).to eq(2)
      end
    end

    describe '#full_name' do
      it 'combines the first and last name of a customer' do
        delete_data

        @cust_1 = create(:customer)
        expect(@cust_1.full_name).to eq("#{@cust_1.first_name} #{@cust_1.last_name}")
      end
    end

    describe '#transaction_count' do
      it 'returns the count of all successful transactions for a merchant by customer' do
        delete_data

        us_3_test_data

        expect(@cust_6.transaction_count(@merch_1)).to eq(6)
        expect(@cust_3.transaction_count(@merch_1)).to eq(4)
        expect(@cust_5.transaction_count(@merch_1)).to eq(2)
      end
    end
  end
end