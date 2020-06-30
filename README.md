# Rails ActionCable Sample App

[![CircleCI](https://circleci.com/gh/habanero2012/rails_action_cable_sample_app.svg?style=svg&circle-token=18c26816b3e785376893c32a10f2aac510e1ea84)](<https://app.circleci.com/github/habanero2012/rails_action_cable_sample_app/pipelines>)

Rails Tutorial の内容に以下の要素を追加したもの

* React, ActionCableによるツイートのリアルタイム受信
* Webpacker,TypeScriptを使用したフロントエンド開発
* Sidekiqによる非同期処理
* RSpecによるテスト
* 画面デザインにAdminLTEのテンプレートを使用
* viewにslimテンプレートを使用
* Docker開発環境
* circleciの自動テスト

## 初期設定

ソースコード一式をダウンロードしたら、下記の1～4のコマンドを順番に実行する

1. DB作成
2. migration実行
3. 初期データ投入
4. アプリケーション起動

#### DB作成
```bash
sudo docker-compose run --rm app rake db:create
```

#### migration実行
```bash
sudo docker-compose run --rm app rails db:migrate
```

#### 初期データ投入
```bash
sudo docker-compose run --rm app rails db:seed
```

#### DBリセット
```bash
sudo docker-compose run --rm app rails db:migrate:reset
sudo docker-compose run --rm app rails db:seed
```

#### アプリケーション起動
```bash
sudo docker-compose up
```

#### rspec実行
```bash
sudo docker-compose run --rm -e RAILS_ENV=test app rspec
```
※systemスペックのブラウザ実行を確認するにはstandalone-chrome-debugにvnc接続する
(password: secret)

#### gem更新
```bash
sudo docker-compose run --rm app bundle
sudo docker-compose build # image 更新
```

### ECRリポジトリにimageアップロード
```bash
aws ecr get-login-password | sudo docker login --username AWS --password-stdin リポジトリURL # ECRログイン
sudo docker-compose -f docker-compose-production.yml build # docker imageのビルド
sudo docker tag タグ名/イメージ名
sudo docker push リポジトリ名/リポジトリタグ
```