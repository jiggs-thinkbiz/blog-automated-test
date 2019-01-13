require 'rails_helper'

RSpec.describe 'Post page', type: :request do

  context 'INDEX : List out all post' do
    let(:articles) { Post.all }

    it 'Load all posts title' do
      get '/posts'
      expect(response).to render_template('index')
      expect(response.body).to include('All posts')
    end
  end
  context 'SHOW : render post page' do
    let(:post) { create(:post) }

    # show (No Authentication)
    it 'Render post page with a slug' do
      get "/posts/#{post.slug}"
      expect(response).to render_template(:show)
      expect(response.body).to include(post.title)
    end
  end

  context 'NEW : Load new page' do
    let(:user) { create(:user) }

    it '(Unauthenticated) Does not load new page' do
      get '/posts/new'
      expect(response).to redirect_to new_user_session_path
    end

    it '(Authenticate) Does load new page' do
      sign_in(user)
      get '/posts/new'
      expect(response).to render_template(:new)
    end
  end

  context 'CREATE : Create new post' do
    let(:user) { create(:user) }
    let(:post_attributes) { attributes_for(:post) }

    it '(Unauthenticated) Does not create post' do
      post '/posts', params: { post: post_attributes }
      expect(response).to redirect_to new_user_session_path
    end

    it '(Auhtenticated) Does create post' do
      sign_in(user)

      post '/posts', params: { post: post_attributes }

      expect(response).to redirect_to(assigns(:post))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include(post_attributes[:title])
    end
  end

  context 'EDIT : Edit post' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    it '(Unauthenticated) Does not load edit page' do
      get "/posts/#{post.slug}/edit"
      expect(response).to redirect_to new_user_session_path
    end

    it '(Auhtenticated) Load edit page' do
      sign_in(user)
      get "/posts/#{post.slug}/edit"
      expect(response).to render_template(:edit)
      expect(response.body).to include('Edit post')
    end
  end

  context 'UPDATE : Update Post' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:post_attributes) { attributes_for(:post) }

    it '(Unauthenticated) Does not update post' do
      put "/posts/#{post.slug}"
      expect(response).to redirect_to new_user_session_path
    end

    it '(Auhtenticated) Does update post' do
      sign_in(user)
      put "/posts/#{post.slug}", params: { post: post_attributes }
      expect(response).to redirect_to(assigns(:post))
      follow_redirect!
      post.reload # To match let(:post) and let(:post_attributes)
      expect(response).to render_template(:show)
      expect(response.body).to include(post_attributes[:title])
      expect(post.title).to eq(post_attributes[:title])
    end
  end

  context 'DELETE : Delete Post' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    it '(Unauthenticated) Should not delete post' do
      delete "/posts/#{post.slug}"
      expect(response).to redirect_to new_user_session_path
    end

    it '(Auhtenticated) Should delete the post' do
      sign_in(user)
      delete("/posts/#{post.slug}")
      expect(response).to redirect_to posts_path
      expect(Post.find_by(slug: post.slug)).to eq(nil)
    end
  end

end