require 'rails_helper'
require './spec/testable'

include Testable

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    describe "::found_on_invoice" do
      it "returns all items found on given invoice for given merchant" do
        us_16_test_data
        expect(Item.found_on_invoice(@merch_1, @invoice_1)).to eq([@item_1, @item_2])
      end
    end
  end
end