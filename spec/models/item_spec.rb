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
end