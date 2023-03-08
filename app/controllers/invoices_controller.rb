class InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.distinct
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = @merchant.invoices.find(params[:id])
    @invoice_items = @invoice.items_with_attributes
    @total_revenue = @invoice.calc_total_revenue
    @discount = @invoice.total_inv_disc
    @disc_total = @invoice.total_disc_rev
    @statuses = ["pending", "packaged", "shipped"]
  end
end
