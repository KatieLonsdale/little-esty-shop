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
    @item.update(item_params)
    @merchant = Merchant.find(params[:merchant_id])
    flash[:notice] = "Item Successfully Updated!"
    redirect_to "/merchants/#{@merchant.id}/items/#{@item.id}"
  end

  private
  def item_params
    params.permit(:description, :unit_price)
  end
end