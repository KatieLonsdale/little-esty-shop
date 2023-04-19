class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  enum status: { "in progress" => 0, completed: 1, cancelled: 2 }

  def self.in_progress
    where("status = 0")
  end

  def created_day_mdy
    created_at.strftime('%A, %B %d, %Y')
  end

  def total_revenue
    invoice_items.sum('invoice_items.quantity * invoice_items.unit_price') / 100.to_f
  end
end
