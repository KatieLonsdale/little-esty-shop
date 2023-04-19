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
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:item_id])
    if params[:item]
      if @item.update(item_params)
        flash[:notice] = "Item Successfully Updated!"
        redirect_to "/merchants/#{@merchant.id}/items/#{@item.id}"
      end
    else
      @item.toggle_status
      redirect_to "/merchants/#{@item.merchant.id}/items"
    end
  end

  private
  def item_params
    params.permit(:description, :unit_price)
  end
end