require 'rails_helper.rb'

RSpec.describe 'ログイン前', type: :system do
  describe 'サイドバー' do
    it '使い方をクリックすると、how_to_useに遷移すること' do
      visit root_path
      click_link '使い方'
      expect(page).to have_content('オシカツ！について')
    end

    it 'お問い合わせをクリックすると、管理者のXに遷移すること' do
      visit root_path
      click_link 'お問い合わせ'
      expect(page).to have_current_path('https://twitter.com/ShimejiOnRails', url: true)
    end

    it 'プライバシーポリシーをクリックすると、privacy_policy_pathに遷移すること' do
      visit root_path
      click_link 'プライバシーポリシー'
      expect(page).to have_content('当社はお客様から')
    end

    it '利用規約をクリックすると、terms_of_useに遷移すること' do
      visit root_path
      click_link '利用規約'
      expect(page).to have_content('第1条')
    end
  end

  describe 'ログインが必要な機能' do
    it 'ログイン前では新規投稿ができないこと' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'a'
      click_button '投稿する'
      visit root_path
      expect(page).to have_content('ログアウト')
      click_link 'ログアウト'
      sleep 2
      visit new_post_path
      sleep 2
      expect(current_path).to eq(new_session_path)
    end

    it 'ログイン前ではいいねができないこと'do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'a'
      click_button '投稿する'
      visit root_path
      click_link 'ログアウト'
      sleep 2
      expect(page).to have_selector('.like-icon')
      find('.like-icon').click
      expect(page).to have_content('ログインが必要な機能です')
    end

    it 'ログイン前ではコメントができないこと' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'a'
      click_button '投稿する'
      sleep 2
      click_link 'ログアウト'
      sleep 2
      find('.image-container').click
      click_button 'コメントする'
      expect(page).to have_content('ログインが必要な機能です')
    end

    it 'ログイン前ではユーザー編集ができないこと' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link 'ログアウト'
      sleep 2
      visit edit_user_path(1)
      expect(page).to have_content('他のユーザーの編集は行えません')
    end
  end

  describe '新規登録' do
    it '新規登録ができること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button '登録する'
      expect(page).to have_content('新規登録に成功しました')
    end

    it '新規登録に失敗すること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'test'
      fill_in 'user_password', with: 'pass'
      fill_in 'user_password_confirmation', with: 'pass'
      click_button '登録する'
      expect(page).to have_content('新規登録に失敗しました')
    end
  end
end
