require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices).through(:items) }
  end
end