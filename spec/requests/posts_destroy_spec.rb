require "rails_helper"

RSpec.describe "投稿の削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:toukou) { create(:post, user: user) }

  context "ログインしていて、自分の投稿を削除する場合" do
    it "処理が成功し、トップページにリダイレクトすること" do
      login_for_request(user)
      expect {
        delete post_path(toukou)
      }.to change(Post, :count).by(-1)
      redirect_to user_path(user)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end

  context "ログインしていて、他人の投稿を削除する場合" do
    it "処理が失敗し、トップページへリダイレクトすること" do
      login_for_request(other_user)
      expect {
        delete post_path(toukou)
      }.not_to change(Post, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      expect {
        delete post_path(toukou)
      }.not_to change(Post, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
