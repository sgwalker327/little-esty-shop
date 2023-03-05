class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    # require 'pry'; binding.pry
  end

  def show
    @discount = Discount.find(params[:id])
    # require 'pry'; binding.pry
  end
end