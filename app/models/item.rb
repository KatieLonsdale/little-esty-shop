class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  enum status: { disabled: 0, enabled: 1 }

  def opposite_status
    enabled? ? 'Disable' : 'Enable'
  end
end