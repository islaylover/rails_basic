# Prepartation
# 
# 1:edit Gemfile
# ----start----
#group :development, :test do
# ・
#  gem 'factory_bot_rails', '~> 4.11' <<--- add
#end 
#
#group :test do
# ・
# add rspec for test code
# gem 'rspec-rails', '~> 3.7' <<--- add
#end
# ・
# gem 'mini_racer' <<--- add
# ----end----
# 
# 2:install
# bundle install
#
# 3:rm default test folder
# rm -fr ./test 
# 
# 4: uninstall gem 'chromedriver-helper'
# gem uninstall chromedriver-helper
# 
# 5:DL and install chromedriver and google-chrome
# wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
# apt-get update
# apt-get install google-chrome-stable
# apt-get install libnss3-dev
# wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
# unzip chromedriver_linux64.zip
# root@xxxxx# mv chromedriver /usr/bin/chromedriver 
# root@xxxxx# vi ~/.bashrc
# --------start--------
# root@1041c928eed4:/app# 
# PATH="$PATH":/usr/bin/chromedriver
# --------end--------
# root@xxxxx# source ~/.bashrc
# root@xxxxx# chromedriver -v
#
# 6: edit spec/spec_helper.rb 
# vi spec/spec_helper.rb 
# config.before(:each, type: :system) do
#   driven_by :selenium, using: :headless_chrome, screen_size: [1280, 800], options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }
# end
#
# exec rspec test
# bundle exec rspec spec/system/tasks_spec.rb 

require 'rails_helper'

describe 'タスク管理機能', type: :system do

  #user_a, userbにそれぞれ定義 <let :変数が初めて使用された時だけ遅延評価>
  let(:user_a) {FactoryBot.create(:user, name: 'ユーザーA', email: 'user_a@example.com')}
  let(:user_b) {FactoryBot.create(:user, name: 'ユーザーB', email: 'user_b@example.com')}
  # 作成者が定義した「user_a」のタスク<let!: 定義された時に実行>
  let!(:task_a) {FactoryBot.create(:task, name: '最初のタスク', user: user_a)}
  
  before do
    # access login page
    visit login_path

    # 共通化したログイン処理[user_a, user_b]
    find('#session_email', visible: true).set login_user.email 
    find('#session_password', visible: true).set login_user.password
    click_button 'ログインする'
  end

  # define shared_examples
  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it {expect(page).to have_content '最初のタスク'}
  end

  describe '一覧表示' do
  
    # Test 1
    context 'ユーザーAがログインしている' do

      #before部の共通処理の「login_user」にuser_aをセット
      let(:login_user) { user_a } 
      
      #it 'ユーザーAが作成したタスクが表示される' do
        # 作成済みのタスク名称が画面上に表示されていることを確認
      #  expect(page).to have_content '最初のタスク'
      #end
      #or
      it_behaves_like 'ユーザーAが作成したタスクが表示される'      

    end

    # Test 2
    context 'ユーザーBがログインしている' do
      #before部の共通処理の「login_user」にuser_bをセット
      let(:login_user) { user_b } 

      it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスク名称が画面上に表示されないことを確認
        expect(page).to have_no_content '最初のタスク'
      end 
    end
    
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
    
      before do
        visit task_path(task_a)
      end

      # use shared_example case
      it_behaves_like 'ユーザーAが作成したタスクが表示される'   
      # or
      #it 'ユーザーAが作成したタスクが表示される' do
      #  expect(page).to have_content '最初のタスク'
      #end
    end
  end

  describe '新規作成機能' do 
    
    let(:login_user) { user_a }
    
    before do
      visit new_task_path
      fill_in '名称', with: task_name
      #find('#task_name', visible: true).set task_name
      click_button '登録する'
    end
    
    context '新規作成画面で名称入力したとき' do  
      let(:task_name) { '新規作成のテストを書く' }
      
      it '正常に登録できる' do 
        # task 一覧ページ上部メッセージに「新規作成のテストを書く」が含まれる
        expect(page).to have_selector :css, '.alert-success', text: '新規作成のテストを書く'
      end
    end
    
    context '新規作成画面で名称入力しなかったとき' do  
      let(:task_name) { '' }
      
      it 'エラーとなる' do 
        # task 新規登録画面の上部メッセージに「名称を入力してください」が含まれる
        expect(page).to have_content '名称を入力してください'
      end
    end
  end

end