class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :items, through: :invoices

  def self.top_five_cust
    joins(:transactions).select("customers.*, count(transactions.id) as transaction_count").where("result = 1").group(:id).order("transaction_count desc").limit(5)
  end

  def success_count
    transactions.success.count
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end