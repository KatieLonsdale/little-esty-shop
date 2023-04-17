class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.found_on_invoice(merchant, invoice)
    joins(:merchant, :invoices)
    .where("merchants.id=? AND invoices.id=?", merchant, invoice)
    .distinct
  end
end