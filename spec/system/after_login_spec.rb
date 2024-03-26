require 'rails_helper.rb'

RSpec.describe 'ログイン後', type: :system do
  describe '検索' do
    it '検索ができること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'りんご'
      click_button '投稿する'
      expect(page).to have_content('投稿しました')
      visit root_path
      fill_in 'q_name_cont', with: 'りんご'
      click_button '検索'
      expect(page).to have_content('りんご')
    end

    it '検索がヒットしないこと' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'りんご'
      click_button '投稿する'
      expect(page).to have_content('投稿しました')
      visit root_path
      fill_in 'q_name_cont', with: 'みかん'
      click_button '検索'
      expect(page).not_to have_content('りんご')
    end
  end

  describe 'ログアウト' do
    it 'ログアウトできること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      expect(page).to have_content('新規登録に成功しました')
      visit root_path
      click_link 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end

  describe 'コメント' do
    it 'コメントができること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      expect(page).to have_content('新規登録に成功しました')
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'りんご'
      click_button '投稿する'
      expect(page).to have_content('投稿しました')
      visit root_path
      find('.image-container').click
      fill_in 'comment_body', with: 'a'
      click_button 'コメントする'
      expect(page).to have_content('コメントを投稿しました')
    end

    it '200文字を超えるとコメントに失敗すること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      click_link '投稿する'
      attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
      fill_in 'post_name', with: 'りんご'
      click_button '投稿する'
      expect(page).to have_content('投稿しました')
      visit root_path
      find('.image-container').click
      fill_in 'comment_body', with: 'オエrjンゴdfボア絵フィンrbお亜鉛frbおv毛dfんb聲krfんbvオエ色
      bnvウィjべvwjべdv自br卯wヴィjsbwれういgjlvb義wrゔぃbsをerbうごvnbr擬右jんv市王brwごvjwbエゴv
      onweorgnwoeingfwourehg4wodeiruhg4owihug342oiwajp2340ughnowapvegihu234io0wpvn4nfie4
      ownegiof3o4iunw3irgunowkangihq3wrh3o4nvr35houvijwn3hvdw34hgviw3h4npiq34hpvqwdrhngoqiw3
      nwoie43hgnopqiwengo3ru5gnowuinvgnaoqw3ngbi3b4wjorgibw3igbijqu34gpiouw3hrgpiw3ugh4;3'
      click_button 'コメントする'
      expect(page).to have_content('コメントは200文字以内にしてください')
    end
  end

  describe 'ユーザー編集' do
    it 'ユーザー編集ができること' do
      visit root_path
      click_link '新規登録'
      fill_in 'user_email', with: 'a@a.a'
      fill_in 'user_password', with: 'aaaaaaaa'
      fill_in 'user_password_confirmation', with: 'aaaaaaaa'
      click_button '登録する'
      expect(page).to have_content('新規登録に成功しました')
      visit root_path
      find('.header-user-icon').click
      click_link 'プロフィールを編集'
      fill_in 'user-name', with: 'a'
      click_button '変更する'
      expect(page).to have_content('ユーザー情報を更新しました')
    end
  end
end
