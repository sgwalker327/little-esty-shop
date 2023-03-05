require 'rails_helper'

RSpec.describe 'merchant/:id/discounts/:id/edit', type: :feature do
  before do
    @merchant21 = create(:merchant)
    @merchant22 = create(:merchant)
    @discount1 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.2, threshold: 10)
    @discount2 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.33, threshold: 20)
    visit edit_merchant_discount_path(@merchant21.id, @discount1.id)
  end

  describe 'when I visit the edit merchant discount page' do
    it 'It displays an edit discount form with prepopulated discount info' do
      
      expect(page).to have_content("Edit Discount ##{@discount1.id}")
      expect(page).to have_field("Percent:")
      expect(page).to have_field("Quantity Threshold:")
      expect(page).to have_field("Quantity Threshold:", with: "10")
      expect(page).to have_field("Percent:", with: "0.2")
    end

  end
end