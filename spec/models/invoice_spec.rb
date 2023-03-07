require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationship' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items)}
  end

  describe '.incomplete' do
    before do
      @customer = create(:customer)
      @invoice1 = create(:invoice, customer_id: @customer.id)
      @invoice2 = create(:invoice, customer_id: @customer.id, created_at: Time.new(1999))
      @invoice3 = create(:invoice, customer_id: @customer.id)
      @invoice4 = create(:invoice, customer_id: @customer.id, created_at: Time.new(2022))
      @invoice5 = create(:invoice, customer_id: @customer.id, created_at: Time.new(2002))
      @merchant = create(:merchant)
      @item = create(:item, merchant_id: @merchant.id)
      
      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item.id, status: 2)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item.id, status: 0)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item.id, status: 2)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item.id, status: 0)
      @invoice_item5 = create(:invoice_item, invoice_id: @invoice5.id, item_id: @item.id, status: 1)
    end

    it 'returns an array of incomplete invoices' do
      expect(Invoice.incomplete).to contain_exactly(@invoice2, @invoice4, @invoice5)
    end

    it 'is ordered by date created at' do
      expect(Invoice.incomplete).to eq([@invoice2, @invoice5, @invoice4])
    end

    it 'lists its items with their relational invoice atrributes' do
      expect(@invoice1.items_with_invoice_attributes.first.name).to eq(@item.name)
      expect(@invoice1.items_with_invoice_attributes.first.quantity).to eq(@invoice_item1.quantity)
      expect(@invoice1.items_with_invoice_attributes.first.unit_price).to eq(@invoice_item1.unit_price)
      expect(@invoice1.items_with_invoice_attributes.first.status).to eq(@invoice_item1.status)
    end
  end

  describe '#calc_total_revenue' do
    it 'lists total revenue for an invoice' do
      merchant10 = create(:merchant)
      item10 = create(:item, merchant_id: merchant10.id)
      customer10 = create(:customer)
      invoice10 = create(:invoice, customer_id: customer10.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 2)
      invoice_item2 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 5)
      
      expect(invoice10.calc_total_revenue).to eq(70)

      invoice_item3 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 3)

      expect(invoice10.calc_total_revenue).to eq(100)
    end
  end

  describe '#total_dicount' do
    it 'returns the total discount on an invoice' do
      merchant10 = create(:merchant)
      merchant20 = create(:merchant)
      item10 = create(:item, merchant_id: merchant10.id)
      item11 = create(:item, merchant_id: merchant10.id)
      item12 = create(:item, merchant_id: merchant10.id)
      item13 = create(:item, merchant_id: merchant20.id)
      item14 = create(:item, merchant_id: merchant20.id)
      item15 = create(:item, merchant_id: merchant20.id)
      customer10 = create(:customer)
      customer20 = create(:customer)
      invoice10 = create(:invoice, customer_id: customer10.id)
      invoice20 = create(:invoice, customer_id: customer20.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 35)
      invoice_item2 = create(:invoice_item, invoice_id: invoice10.id, item_id: item11.id, quantity: 7, unit_price: 20)
      invoice_item3 = create(:invoice_item, invoice_id: invoice10.id, item_id: item12.id, quantity: 4, unit_price: 30)
      invoice_item4 = create(:invoice_item, invoice_id: invoice20.id, item_id: item13.id, quantity: 10, unit_price: 70)
      invoice_item5 = create(:invoice_item, invoice_id: invoice20.id, item_id: item14.id, quantity: 12, unit_price: 50)
      invoice_item6 = create(:invoice_item, invoice_id: invoice20.id, item_id: item15.id, quantity: 4, unit_price: 30)
      merchant10.discounts.create!(percent: 0.20, threshold: 10)
      merchant10.discounts.create!(percent: 0.10, threshold: 5)
      merchant20.discounts.create!(percent: 0.15, threshold: 7)
      merchant20.discounts.create!(percent: 0.33, threshold: 10)

      
      expect(invoice10.total_inv_disc).to eq(84.00)
      expect(invoice20.total_inv_disc).to eq(429.00)
    end
  end

  describe '#total_disc_rev' do
    it 'returns the total discounted revenue on an invoice' do
      merchant10 = create(:merchant)
      merchant20 = create(:merchant)
      item10 = create(:item, merchant_id: merchant10.id)
      item11 = create(:item, merchant_id: merchant10.id)
      item12 = create(:item, merchant_id: merchant10.id)
      item13 = create(:item, merchant_id: merchant20.id)
      item14 = create(:item, merchant_id: merchant20.id)
      item15 = create(:item, merchant_id: merchant20.id)
      customer10 = create(:customer)
      customer20 = create(:customer)
      invoice10 = create(:invoice, customer_id: customer10.id)
      invoice20 = create(:invoice, customer_id: customer20.id)
      invoice_item1 = create(:invoice_item, invoice_id: invoice10.id, item_id: item10.id, quantity: 10, unit_price: 35)
      invoice_item2 = create(:invoice_item, invoice_id: invoice10.id, item_id: item11.id, quantity: 7, unit_price: 20)
      invoice_item3 = create(:invoice_item, invoice_id: invoice10.id, item_id: item12.id, quantity: 4, unit_price: 30)
      invoice_item4 = create(:invoice_item, invoice_id: invoice20.id, item_id: item13.id, quantity: 10, unit_price: 70)
      invoice_item5 = create(:invoice_item, invoice_id: invoice20.id, item_id: item14.id, quantity: 12, unit_price: 50)
      invoice_item6 = create(:invoice_item, invoice_id: invoice20.id, item_id: item15.id, quantity: 4, unit_price: 30)
      merchant10.discounts.create!(percent: 0.20, threshold: 10)
      merchant10.discounts.create!(percent: 0.10, threshold: 5)
      merchant20.discounts.create!(percent: 0.15, threshold: 7)
      merchant20.discounts.create!(percent: 0.33, threshold: 10)
      

      expect(invoice10.calc_total_revenue).to eq(610.00)
      expect(invoice10.total_inv_disc).to eq(84.00)
      expect(invoice10.total_disc_rev).to eq(526.00)
      expect(invoice20.calc_total_revenue).to eq(1420.00)
      expect(invoice20.total_inv_disc).to eq(429.00)
      expect(invoice20.total_disc_rev).to eq(991.00)
    end
  end
end
