require 'rails_helper'
require './spec/testable'

include Testable

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end
end