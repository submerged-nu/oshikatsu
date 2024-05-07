
![twitter_card](https://github.com/submerged-nu/oshikatsu/assets/141556890/d03327fd-f993-41dd-aed9-ff1b2612ce08)
## ■サービス概要
webアプリ「オシカツ！」は推しの好きなところを語れて共有できるアプリです。<br>
他サービスとの差別化点としてキャラクターに焦点をあげています。<br>
具体的にはタグ機能、いいね履歴からおすすめ機能を実装したほか、キャラクターごとに投稿数、いいね、コメントを<br>
集計することでキャラクターランキング機能を実装しました<br>
これらの機能により新しい推しを見つけるほか、今流行のキャラクターを見つけることができます

#### ▼サービスURL
https://www.oshikatsu-app.com<br>

#### ▼Qiita記事


#### ▼告知ツイート


## ■開発背景
好きなキャラクターの絵や動画を作ることが趣味でyoutubeやpixivなどを利用しています。<br>
そこでキャラクターに焦点を当てたアプリがないことに気づき作成しました。


## ■主な機能
### 投稿機能
![投稿機能](https://github.com/submerged-nu/oshikatsu/assets/141556890/41044e63-99ed-42ba-8f8e-1ff2632f4134)<br>
cropper.jsを使用した画像切り抜き機能、cocoonを使用したタグ機能により投稿のしやすさを上げました
***
### おすすめ機能
![おすすめ機能](https://github.com/submerged-nu/oshikatsu/assets/141556890/9dce460d-4884-4b7c-8df9-4c5194a367b3)<br>
ユーザーのいいね履歴と投稿のタグ機能にからおすすめ機能を作成しました
***
### ユーザー編集機能
![ユーザー編集](https://github.com/submerged-nu/oshikatsu/assets/141556890/2ed84219-00d2-4b56-8052-83971bd212c8)<br>
cropper.jsによる画像切り抜き機能でユーザー編集機能を作成しました
***
### 投稿検索機能
![ezgif com-video-to-gif-converter](https://github.com/submerged-nu/oshikatsu/assets/141556890/ac231acd-2eb0-4a35-afcf-e8acfc650dba)<br>
ransackというgemを使用し、検索機能を作成しました。またオートコンプリートの実装により検索が快適になっています
***
### 通知機能
![通知機能](https://github.com/submerged-nu/oshikatsu/assets/141556890/2fdafd3a-3d68-47dc-a2dd-2a5f602f742b)<br>
RailsのAction Cableを使用し、Websocket通信によるリアルタイム通知機能を実装しました
***
### ランキング機能
<br>
キャラクターごとに集計されたいいね、コメント、投稿数からスコア算出することでランキング機能を実装しました<br>

***
### その他機能
ソーシャルログイン<br>
キャラクター名オートコンプリート<br>
Xへの共有機能

## ■使用技術
### フロントエンド<br>
- Bootstrap<br>
- Hotwire(Turbo,Action Cable)<br>

### バックエンド<br>
- Ruby 3.1.4
- Ruby on Rails 7.0.8
- PostgreSQL

### gem<br>
- carrierwave
- fog-aws
- kaminari
- ransack
- sorcery
- cocoon


### インフラ<br>
- Heroku
- S3
## ■ER図
![ER図 drawio](https://github.com/submerged-nu/oshikatsu/assets/141556890/ccc622ba-11b1-43f6-97dd-e0f7c4b10e7e)

