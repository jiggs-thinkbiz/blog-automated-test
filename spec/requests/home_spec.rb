require 'rails_helper'

RSpec.describe 'home page', type: :request do
  context 'render home page' do
    let(:post) { create(:post) }

    before do
        post.published!
    end

    it 'render home page correctly when site called' do
        get '/'
        expect(response).to render_template(:index)
        expect(response.body).to include('Home')
    end

    it 'render home page with posts' do
        get '/'
        expect(response).to render_template(:index)
        expect(response.body).to include(post.title)
    end
  end
end