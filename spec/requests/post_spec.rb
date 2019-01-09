require 'rails_helper'

RSpec.describe 'Post page', type: :request do
  context 'render post page' do
    let(:post) { create(:post) }

    # show (No Authentication)
    it 'Render post page with a slug' do
      get "/posts/#{post.slug}"
      expect(response).to render_template(:show)
      expect(response.body).to include(post.title)
    end
  end

  context 'Create new post page (Unauthorized)' do
    # new (Authenticated) without login
    it 'Does not load new page if not authenticated' do
      get '/posts/new'
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'Create new post page (Authorized)' do
    let(:user) { create(:user) }
    let(:post_attributes) { attributes_for(:post) }

     # new (Authenticated) with login
    it 'Does not load new page if not authenticated' do
      sign_in(user)
      get '/posts/new'
      expect(response).to render_template(:new)
      expect(response.body).to include('New Post')

      post '/posts', params: { post: post_attributes }

      expect(response).to redirect_to(assigns(:post)) 
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include(post_attributes[:title])
    end
  end

end