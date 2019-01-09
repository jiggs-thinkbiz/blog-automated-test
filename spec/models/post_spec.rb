require 'rails_helper'

RSpec.describe Post, type: :model do
  it "has a valid factory" do
    expect(build(:post)).to be_valid
  end

  describe 'Activerecord validations' do
    context "basic validations" do
      let(:post) { build(:post, title: nil) }

      it "is invalid without a title" do
        expect(post).to validate_presence_of(:title)
      end

      it "is invalid without a title" do
        should validate_presence_of(:title)
      end
    end

    context "format validtions" do
      let(:post) { build(:post) }

      it "validates the format of email" do
        expect(post).to allow_value(Faker::Internet.email).for(:email)
        expect(post).not_to allow_value('fsk33###%%.com').for(:email)
      end

      it "validates the format of email" do
        should allow_value(Faker::Internet.email).for(:email)
        should_not allow_value('fsk33###%%.com').for(:email)
      end
    end
  end

  describe 'ActiveRecord Associations' do
    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }

    it { should have_many(:comments) }
    it { expect(post).to have_many(:comments) }
  end

  describe 'ActiveRecord Callbacks' do
    let(:post) { build_stubbed(:post) }

    it "should generate and save a slug on create" do
      post.run_callbacks :create
      expect(post.slug).not_to be_empty
    end
  end

  describe 'ActiveRecord Scopes' do
    3.times.each do |count|
      let!("post_#{count + 1}".to_sym) { create(:post) }
    end

    before do
      post_1.published!
      post_3.published!
    end

    it '.published returns all the published posts' do
      expect(Post.published.count).to eq 2
    end

    it '.draft returns all draft posts' do
      expect(Post.draft.count).to eq 1
    end
  end

  describe 'Model public class methods' do
    let(:post) { create(:post) }

    context 'responds to methods' do
      it { expect(post.class).to respond_to(:posts_by_email) }
    end

    context 'executes class method correctly' do
      it '.posts_by_email returns all posts by an email' do
        posts = Post.posts_by_email(post.email)
        expect(posts.first).to eq post
      end
    end
  end

  describe 'Model public instance methods' do
    let(:post) { build(:post) }

    context 'responds to methods' do
      it { expect(post).to respond_to(:truncated_post) }
    end

    context 'executes methods correctly' do
      it '#truncates the post body to 25 characters' do
        short_post = post.truncated_post
        expect(short_post.length).to eq 25
      end
    end
  end
end