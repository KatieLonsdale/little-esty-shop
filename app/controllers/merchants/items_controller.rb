class Merchants::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @items = @merchant.items
  end

  def show
    #require 'pry'; binding.pry
    @item = Item.find(params[:item_id])
  end

  def update
    @item = Item.find(params[:id])
    @item.toggle_status
    redirect_to "/merchants/#{@item.merchant.id}/items"
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :status)
  end
end