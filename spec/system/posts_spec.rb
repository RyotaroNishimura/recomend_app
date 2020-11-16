require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe "本の登録ページ" do
    before do
      login_for_system(user)
      visit new_post_path
    end

    context "ページレイアウト" do
      it "「本の登録」の文字列が存在すること" do
        expect(page).to have_content '本の登録'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('本の登録')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'タイトル'
        expect(page).to have_content 'カテゴリー'
        expect(page).to have_content '値段'
        expect(page).to have_content '人気度 [1~5]'
        expect(page).to have_content '詳細'
      end
    end
    context "本の登録処理" do
      it "有効な情報で本の登録を行うと本の登録成功のフラッシュが表示されること" do
        fill_in "タイトル", with: "七つの習慣"
        fill_in "カテゴリー", with: "政治"
        fill_in "値段", with: 1500
        fill_in "人気度", with: 5
        fill_in "詳細", with: "初めて本を紹介した"
        click_button "投稿"
        expect(page).to have_content "投稿が作られました!"
      end

      it "無効な情報で料理登録を行うと料理登録失敗のフラッシュが表示されること" do
        fill_in "タイトル", with: ""
        fill_in "カテゴリー", with: "政治"
        fill_in "値段", with: 1500
        fill_in "人気度", with: 5
        fill_in "詳細", with: "初めて本を紹介した"
        click_button "投稿"
        expect(page).to have_content "タイトルを入力してください"
      end
    end
  end

  describe "本の詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit post_path(post)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{post.title}")
      end

      it "料理情報が表示されること" do
        expect(page).to have_content post.title
        expect(page).to have_content post.category
        expect(page).to have_content post.content
        expect(page).to have_content post.price
        expect(page).to have_content post.popularity
      end
    end

    context "投稿の削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit post_path(post)
        within find('.change-post') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿が削除されました'
      end
    end
  end

  describe "料理編集ページ" do
    before do
      login_for_system(user)
      visit post_path(post)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('本の情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '詳細'
        expect(page).to have_content 'カテゴリー'
        expect(page).to have_content '値段'
        expect(page).to have_content '人気度[1~5]'
      end
    end

    context "本の更新処理" do
      it "有効な更新" do
        fill_in "タイトル", with: "編集：七つの習慣"
        fill_in "詳細", with: "編集：初めて本を紹介した"
        fill_in "カテゴリー", with:"編集：政治"
        fill_in "値段", with: 1500
        fill_in "人気度", with: 1
        click_button "更新する"
        expect(page).to have_content "本の情報が更新されました！"
        expect(post.reload.title).to eq "編集：七つの習慣"
        expect(post.reload.content).to eq "編集：初めて本を紹介した"
        expect(post.reload.price).to eq 1500
        expect(post.reload.popularity).to eq 1
      end

      it "無効な更新" do
        fill_in "タイトル", with: ""
        click_button "更新する"
        expect(page).to have_content 'タイトルを入力してください'
        expect(post.reload.title).not_to eq ""
      end
    end

    context "投稿の削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿が削除されました'
      end
    end
  end
end
