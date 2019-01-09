require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "ActiveRecord associations" do
    let(:comment) { create(:comment) }

    it { should belong_to(:post) }
    it { expect(comment).to belong_to(:post) }
  end
end
