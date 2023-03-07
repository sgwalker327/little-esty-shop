require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe '#instance methods' do
    describe '#top_discount' do
      it 'returns the top discount for an invoice item' do
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
        discount1 = merchant10.discounts.create!(percent: 0.20, threshold: 10)
        discount2 = merchant10.discounts.create!(percent: 0.10, threshold: 5)
        discount3 = merchant20.discounts.create!(percent: 0.15, threshold: 7)
        discount4 = merchant20.discounts.create!(percent: 0.33, threshold: 10)

        expect(invoice_item1.top_discount).to eq(discount1)
        expect(invoice_item2.top_discount).to eq(discount2)
        expect(invoice_item3.top_discount).to eq(nil)
        expect(invoice_item4.top_discount).to eq(discount4)
      end
    end
  end
end
