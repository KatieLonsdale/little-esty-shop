class Merchants::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
  end
end