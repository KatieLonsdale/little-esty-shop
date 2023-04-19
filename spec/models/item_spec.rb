require 'rails_helper'
require './spec/testable'

include Testable

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'enum' do
    it 'defines status as enum' do
      should define_enum_for(:status).
        with_values(disabled: 0, enabled: 1)
    end
  end

  describe 'instance methods' do
    before(:all) do
      us_9_test_data
    end
    describe '#opposite_status' do 
      it 'returns the opposite status' do
        expect(@item_1.opposite_status).to eq('Enable')
        expect(@item_2.opposite_status).to eq('Disable')
      end
    end
    describe '#toggle_status' do
      it 'changes the status of the item' do
        @item_1.toggle_status
        @item_2.toggle_status

        expect(@item_1.status).to eq('enabled')
        expect(@item_2.status).to eq('disabled')
      end
    end
  end
end