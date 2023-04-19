class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  enum status: { disabled: 0, enabled: 1 }

  def favorite_customers
    customers.joins(transactions: [invoice: { invoice_items: :item }])
             .where("items.merchant_id = ? AND transactions.result = ?", id, 1)
             .select("customers.*, COUNT(DISTINCT invoice_items.id) AS purchase_count")
             .group("customers.id")
             .order("purchase_count DESC")
             .limit(5)
  end

  def items_ready
    ready_items = invoice_items.where.not(status: 2).distinct
    ready_items.sort_by {|ii| [ii.invoice.created_at, ii.created_at]}
  end

  def unique_invoices
    invoices.distinct
  end

  def items_on_invoice(invoice)
    invoice_items.joins(:item)
                 .where("items.merchant_id=? and invoice_id=?",id,invoice)
                 .order("items.name")
  end

  def opposite_status
    if self.enabled?
      'Disable'
    else
      'Enable'
    end
  end

  def total_revenue(invoice)
    revenue = 0
    items_on_invoice(invoice).each do |item|
      revenue += (item.unit_price * item.quantity)
    end
    revenue
  end

  def self.top_five_merch_by_revenue
    select("merchants.name, merchants.id, SUM(invoice_items.unit_price / 100 * invoice_items.quantity) AS total_rev")
      .joins(invoices: :transactions)
      .where(transactions: {result: 1})
      .group(:id)
      .order("total_rev DESC")
      .limit(5)
  end
end

