require 'rails_helper'

describe PublicController do
  render_views

  describe '#index' do
    it 'responds successfully' do
      process :index, method: :get
      expect(response.status).to eq(200)
    end
  end
end
