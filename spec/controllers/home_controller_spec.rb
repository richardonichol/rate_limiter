require 'rails_helper'

RSpec.describe HomeController, type: :controller do 
  
  describe 'GET /home' do
    it 'says ok' do
      get 'index'
      expect(response.body).to eq({message: 'ok'}.to_json)
    end

    it 'gives 200 status if rate limit is not exceeded' do
      HomeController.any_instance.stub(:ip_is_blocked?).and_return(false)
      get 'index'
      expect(response.status).to eq(200)
    end

    it 'gives 429 status if rate limit is exceeded' do
      HomeController.any_instance.stub(:ip_is_blocked?).and_return(true)
      get 'index'
      expect(response.status).to eq(429)
    end

    it 'givs the right message when limit is exceeded' do
      HomeController.any_instance.stub(:ip_is_blocked?).and_return(true)
      HomeController.any_instance.stub(:seconds_left_in_hour).and_return(60)
      get 'index'
      expect(response.body).to eq({message: 'Rate limit exceeded. Try again in 60 seconds.'}.to_json)
    end
  end
end