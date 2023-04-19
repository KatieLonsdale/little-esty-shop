class Merchants::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @items = @merchant.items
  end

  def show
    @item = Item.find(params[:item_id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @item = Item.find(params[:item_id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @item = Item.find(params[:item_id])
    @merchant = Merchant.find(params[:merchant_id])
    
  end
end