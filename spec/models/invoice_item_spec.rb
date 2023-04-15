require 'rails_helper'

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
    describe 'item_name' do
      before(:each) do
        us_4_test_data
      end
      it 'returns the name of the item it is associated with' do
        expect(@pending_item_1.first.item_name).to eq(@item_1.name)
        expect(@packaged_item_2.first.item_name).to eq(@item_2.name)
      end
    end
  end
end