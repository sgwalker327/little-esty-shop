require 'rails_helper'

RSpec.describe 'merchant/:id/discounts', type: :feature do
  before do
    @merchant21 = create(:merchant)
    @merchant22 = create(:merchant)
    @discount1 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.2, threshold: 10)
    @discount2 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.33, threshold: 20)
    @discount3 = @merchant22.discounts.create!(merchant_id: @merchant22.id, percent: 0.40, threshold: 30)
    visit merchant_discounts_path(@merchant21)
  end

  describe 'when I visit the merchant discount index page' do
    it 'displays the available bulk discounts and attributes' do
      expect(page).to have_content("Available Bulk Discounts for #{@merchant21.name}")
      expect(page).to have_content("#{@discount1.percent}% off #{@discount1.threshold} or more items")
      expect(page).to have_content("#{@discount2.percent}% off #{@discount2.threshold} or more items")
      expect(page).to_not have_content("#{@discount3.percent}% off #{@discount3.threshold} or more items")
    end
    
    it 'has a link to each discount\'s show page' do
      within "#discount-#{@discount1.id}" do
        expect(page).to have_link("View Discount")
        click_on "View Discount"
      end

      expect(current_path).to eq("/merchants/#{@merchant21.id}/discounts/#{@discount1.id}")
    end

    it 'has a link to create a new Discount' do

      expect(page).to have_link("Create Discount")

    end

    it 'when I click the link I am redirected a new discount page' do
      click_on "Create Discount"

      expect(current_path).to eq(new_merchant_discount_path(@merchant21))
      ## Continued in spec/features/merchants/discounts/new_spec.rb
    end

    it 'has a button next to each discount to delete it' do
      within "#discount-#{@discount1.id}" do
        expect(page).to have_content("#{@discount1.percent}% off #{@discount1.threshold} or more items")
        expect(page).to have_link("Delete Discount")
        save_and_open_page
        click_link "Delete Discount"
      end

      expect(current_path).to eq(merchant_discounts_path(@merchant21))
      expect(page).to_not have_content("#{@discount1.percent}% off #{@discount1.threshold} or more items")
    end
  end
end