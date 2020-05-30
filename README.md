# Rails Tutorial

[![CircleCI](https://circleci.com/gh/habanero2012/rails_tutorial_sample_app.svg?style=svg&circle-token=cc1470e5238f81f6e4188c1e12909ca26bc46dd6)](<https://app.circleci.com/github/habanero2012/rails_tutorial_sample_app/pipelines>)

Rails Tutorial をrspec,webpackerを使用して作成

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