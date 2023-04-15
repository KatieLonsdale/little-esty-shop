require 'rails_helper'

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
end

def delete_data
  Transaction.delete_all
  InvoiceItem.delete_all
  Item.delete_all
  Invoice.delete_all
  Customer.delete_all
  Merchant.delete_all
end
