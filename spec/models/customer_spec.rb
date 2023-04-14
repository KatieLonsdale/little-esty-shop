require 'rails_helper'

RSpec.describe Customer do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:items).through(:invoices) }
  end

  describe 'class methods' do
    it '.top_five_cust' do
      expect(Customer.top_five_cust).to eq([@cust_1, @cust_2, @cust_3, @cust_4, @cust_5])
    end
  end

  describe 'instance methods' do
    it '#success_count' do
      expect(@cust_1.success_count).to eq(7)
      expect(@cust_5.success_count).to eq(2)
    end
    
    it '#full_name' do
      expect(@cust_1.full_name).to eq("#{@cust_1.first_name} #{@cust_1.last_name}")
    end
  end
end