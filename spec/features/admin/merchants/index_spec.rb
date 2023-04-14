require 'rails_helper'

RSpec.describe '/admin/merchants', type: :feature do
  before(:each) do
    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)
    @merch_3 = create(:merchant)

    visit '/admin/merchants'
  end

  describe 'When I visit the admin merchants index ' do
    it 'I see the name of each merchant in the system' do
      expect(page).to have_content(@merch_1.name)
      expect(page).to have_content(@merch_2.name)
      expect(page).to have_content(@merch_3.name)
    end
  end
end