require 'rails_helper'
require './spec/testable.rb'

include Testable

RSpec.describe InvoiceItem do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'enum' do
    it 'defines status as enum' do
      should define_enum_for(:status).
        with_values(pending: 0, packaged: 1, shipped: 2)
    end
  end

  describe 'instance methods' do
    before(:all) do
      us_4_test_data
    end
    describe 'item_name' do
      it 'returns the name of the item it is associated with' do
        expect(@pending_item_1.first.item_name).to eq(@item_1.name)
        expect(@packaged_item_2.first.item_name).to eq(@item_2.name)
      end
    end
    describe 'invoice_date' do
      it 'returns the date that its invoice was made' do
        @invoice = create(:invoice)
        @invoice.created_at = 'Fri, 14 Apr 2023 20:00:32 UTC +00:00'
        @invoice_item = create(:invoice_item, item: @item_1, invoice: @invoice)
        current_date = "Friday, April 14, 2023"
        expect(@invoice_item.invoice_date).to eq("#{current_date}")
        expect(@invoice_item.invoice_date).to eq("#{current_date}")
      end
    end
  end
end