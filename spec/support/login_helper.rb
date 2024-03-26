module LoginHelper
  def new_user_and_post
    click_link '新規登録'
    fill_in 'user_email', with: 'a@a.a'
    fill_in 'user_password', with: 'aaaaaaaa'
    fill_in 'user_password_confirmation', with: 'aaaaaaaa'
    click_button '登録する'
    click_link '投稿する'
    attach_file('post[image]', Rails.root.join('spec/fixtures/oshikatsu-logo.webp'))
    fill_in 'post_name', with: 'a'
    click_button '投稿する'
    click_link 'ログアウト'
  end
end