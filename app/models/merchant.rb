class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def favorite_customers
    customers.joins(transactions: [invoice: { invoice_items: :item }])
             .where("items.merchant_id = ? AND transactions.result = ?", id, 1)
             .select("customers.*, COUNT(DISTINCT transactions.id) AS transaction_count")
             .group("customers.id")
             .order("transaction_count DESC")
             .limit(5)
    # .joins(transactions: [invoice: { invoice_items: :item }])
    #          .where("transactions.result = ? AND items.merchant_id = ?", 1, id)
    #          .select("customers.*, count(DISTINCT transactions.id) as successful_transactions")
    #          .group("customers.id")
    #          .order("successful_transactions desc")
    #          .limit(5)
  end

  def items_ready
    ready_items = invoice_items.where.not(status: 2).distinct.order(:invoice_id, :id)
    ready_items.sort_by {|ii| [ii.invoice.created_at, ii.created_at]}
  end

  def unique_invoices
    invoices.distinct
  end
end