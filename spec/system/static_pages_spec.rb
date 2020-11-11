require 'rails_helper'

RSpec.describe "スタティックページ", type: :system do

  describe "ホームページ" do

    context "ページ全体" do

      before do
        visit root_path
      end

      it "ホームページがroot_pathであること" do
        expect root_path
      end

      it "タイトルが正しく表示されていること" do
        expect(page).to have_title ('RecomendApp')
      end

      context "投稿フィード", js: true do
        let!(:user) { create(:user) }
        let!(:post) { create(:post, user: user) }

        before do
          login_for_system(user)
        end

        it "投稿のぺージネーションが表示されること" do
          login_for_system(user)
          create_list(:post, 6, user: user)
          visit root_path
          expect(page).to have_content "投稿一覧 (#{user.posts.count})"
          expect(page).to have_css "div.pagination"
          Post.take(5).each do |d|
            expect(page).to have_link p.name
          end
        end

        it "投稿を削除後、削除成功のフラッシュが表示されること" do
          visit root_path
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '投稿が削除されました'
        end
      end
    end
  end
end
