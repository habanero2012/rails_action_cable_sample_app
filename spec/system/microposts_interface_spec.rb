require 'rails_helper'

RSpec.describe 'micropost interface', test: :system, js: true do

  let(:user) { create(:user) }

  xit 'micropost interface' do
    login_as(user)

    visit root_path

    # 無効な送信
    click_button 'ツイートする'
    expect(page).to have_content "Content can't be blank"

    # 有効な送信
    content = 'This micropost really ties the room together'
    expect {
      fill_in 'micropost_content', with: content
      page.find_by_id('micropost_picture').set("#{Rails.root}/spec/files/rails.png")
      click_button 'ツイートする'
      expect(page).to have_current_path root_path
      expect(page).to have_content content
    }.to change(Micropost, :count).by(1)
             .and change(ActiveStorage::Blob, :count).by(1)

    # 投稿を削除する
    expect {
      page.accept_confirm do
        first('.microposts').click_link 'delete'
      end
      sleep 0.5 # リクエストの終了を待つ
    }.to change(Micropost, :count).by(-1)
             .and change(ActiveStorage::Blob, :count).by(-1)
  end

  it 'micropost sidebar count' do
    # micropostが1個のユーザー
    user.microposts.create!(content: 'test content')
    login_as(user)
    visit root_path

    expect(page).to have_content "Microposts\n1"

    # micropostが0個のユーザー
    other_user = create(:user)
    login_as(other_user)
    visit root_path

    expect(page).to have_content "Microposts\n0"
  end
end
