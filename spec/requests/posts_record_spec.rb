require "rails_helper"

RSpec.describe "本の登録", type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  context "ログインしているユーザーの場合" do
    before do
      get new_post_path
      login_for_request(user)
    end

    context "フレンドリーフォワーディング" do
      it "レスポンスが正常に表示されること" do
        expect(response).to redirect_to new_post_url
      end
    end

    it "有効な投稿データで登録できること" do
      expect {
        post posts_path, params: { post: { name: "七つの習慣",
                                            category: "政治",
                                            price: 1500,
                                            popularity: 5,
                                            content: "初めて本を紹介した"
                                            } }
      }.to change(Post, :count).by(1)
      follow_redirect!
      expect(response).to render_template('posts/show')
    end

    it "無効な投稿データでは登録できないこと" do
      expect {
        post posts_path, params: { post: { name: "",
                                            category: "政治",
                                            price: 150,
                                            popularity: 5,
                                            content: "初めて本を紹介した"
                                            } }
      }.not_to change(Post, :count)
      expect(response).to render_template('posts/new')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get new_post_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
