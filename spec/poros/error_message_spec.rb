require 'rails_helper'

RSpec.describe ErrorMessage do
  describe '#initialize' do
    it 'initializes with message and status_code' do
      error_message = ErrorMessage.new('Error message', 404)

      expect(error_message.message).to eq('Error message')
      expect(error_message.status_code).to eq(404)
    end
  end
end