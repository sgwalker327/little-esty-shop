require 'rails_helper'

describe 'Admin Invoices show page' do
  describe 'As an admin' do
    describe 'When I visit the admin invoice show page' do
      let!(:customer_2) {create(:customer) }
      let!(:merchant_2) {create(:merchant) }
      let!(:invoice_2) {create(:invoice, customer_id: customer_2.id, status:'completed', created_at: Time.new(2002)) }
      let!(:item_2) {create(:item, merchant_id: merchant_2.id) }
      let!(:invoice_item_3) {create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id ) }
      let!(:invoice_item_4) {create(:invoice_item, item_id: item_2.id, quantity: 10, unit_price: 9, invoice_id: invoice_2.id ) }
      let!(:transaction_2) {create(:transaction, invoice_id: invoice_2.id, result: 'success') }
  
      it "I see information related to that invoice including: - Invoice id - Invoice status - Invoice created_at date in the format 'Monday, July 18, 2019' - Customer first and last name" do
        visit admin_invoice_path(invoice_2)
  
        expect(page).to have_content("#{invoice_2.id}")
        expect(page).to have_content("#{invoice_2.status}")
        expect(page).to have_content("Tuesday, January 1, 2002")
        expect(page).to have_content("#{invoice_2.customer.first_name}")
        expect(page).to have_content("#{invoice_2.customer.last_name}")
      end

      it "I see all the items on the invoice including: item name, item quantity, price item sold for and invoice item status" do
        visit admin_invoice_path(invoice_2)
        
        within(".items") do
          expect(page).to have_content("#{invoice_2.items.first.name}")
          expect(page).to have_content("#{invoice_item_3.quantity}")
          expect(page).to have_content("#{invoice_item_3.status}")
          expect(page).to have_content("#{invoice_item_3.unit_price}")
        end
      end

      it "I see the total revenue that will be generated from this invoice" do
        visit admin_invoice_path(invoice_2)
        
        expect(page).to have_content("Total Revenue: $1.80")
      end

      it "I see the invoice status is a select field and I see that the invoice's current status is selected when I click this select field. Then I can select a new status for the Invoice, and next to the select field I see a button to 'Update Invoice Status'. When I click this button I am taken back to the admin invoice show page and I see that my Invoice's status has now been updated" do
        visit admin_invoice_path(invoice_2)

        select("in_progress", :from => 'status').click
        click_button('Update Invoice Status')
       
        expect(current_path).to eq(admin_invoice_path(invoice_2))
        expect(page).to have_content("in_progress")

        select("cancelled", :from => 'status').click
        click_button('Update Invoice Status')

        expect(current_path).to eq(admin_invoice_path(invoice_2))
        expect(page).to have_content("cancelled")
      end
    end
    describe 'discounted revenue' do
      before do
        @merchant_1 = create(:merchant)
        @merchant_2 = create(:merchant)
        @customer_1 = create(:customer)
        @customer_2 = create(:customer)
        @item_1 = create(:item, merchant_id: @merchant_1.id)
        @item_2 = create(:item, merchant_id: @merchant_1.id)
        @item_3 = create(:item, merchant_id: @merchant_1.id)
        @item_4 = create(:item, merchant_id: @merchant_2.id)
        @invoice_1 = create(:invoice, customer_id: @customer_1.id, status: 'completed', created_at: "January 28, 2019")
        @invoice_2 = create(:invoice, customer_id: @customer_2.id, status: 'cancelled', created_at: "June 8, 2013")
        @invoice_3 = create(:invoice, customer_id: @customer_2.id, status: 'cancelled', created_at: "May 8, 2013")
        @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, quantity: 10, unit_price: 10, invoice_id: @invoice_1.id, status: 0)
        @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, quantity: 10, unit_price: 8, invoice_id: @invoice_1.id, status: 0 )
        @invoice_item_3 = create(:invoice_item, item_id: @item_4.id, quantity: 8, unit_price: 6, invoice_id: @invoice_3.id, status: 0 )
        @invoice_item_4 = create(:invoice_item, item_id: @item_3.id, quantity: 2, unit_price: 7, invoice_id: @invoice_1.id, status: 0 )
        @merchant_1.discounts.create!(percent: 0.20, threshold: 10)
        @merchant_1.discounts.create!(percent: 0.10, threshold: 5)
        
        
        visit admin_invoice_path(@invoice_1)
      end
      it 'I see the total discounted revenue from this invoice which includes bulk discounts in the calculation' do
        expect(page).to have_content("Total Revenue: $1.94")
        expect(page).to have_content("Total Discounted Revenue: $1.58")
      end
    end
  end
end