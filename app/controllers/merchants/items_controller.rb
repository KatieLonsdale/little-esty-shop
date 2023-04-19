class Merchants::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @items = @merchant.items
  end

  def show
    #require 'pry'; binding.pry
    @item = Item.find(params[:merchant_id])
  end
end