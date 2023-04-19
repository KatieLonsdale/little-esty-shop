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
    describe '#opposite_status' do 
    it 'returns the opposite status' do
      us_9_test_data
      expect(@item_1.opposite_status).to eq('Enable')
      expect(@item_2.opposite_status).to eq('Disable')
    end
  end
  end
end