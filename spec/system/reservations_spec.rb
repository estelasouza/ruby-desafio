RSpec.describe 'Rooms', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'searching' do
    before do
      Room.create!(code: '101', capacity: 1)
    end
    it 'allows users to search for available rooms with a given capacity in a period'
    
  end
end
