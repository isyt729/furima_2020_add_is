## 環境変数
### heroku用にcredential.ymlを利用して、payjp、sns認証を実装しています
　Rails.application.credentialsで検索していただくと、環境変数を利用する記述があるため、そちらを利用してください

### webpacker で環境変数を使用するには

`furima/config/initializers/webpacker.rb`を作成し下記のように記述します。

```ruby
Webpacker::Compiler.env["PAYJP_SK"] = ENV["PAYJP_SK"]
```

あとは js ファイルで下記のように使用するだけです。

```javascript
const PAYJP_SK = process.env.PAYJP_SK;
Payjp.setPublicKey(PAYJP_SK);
```

こちらの記事を参考にしています。
https://qiita.com/takeyuweb/items/61e6ba07fe0df3079041

## rubocop

設定は`.rubocop.yml`を参照。

### チェック

```bash
bundle ex rubocop
```

### チェック＋自動修正

```bash
bundle ex rubocop -a
```

## DB 設計

## users table

| Column             | Type                | Options                 |
|--------------------|---------------------|-------------------------|
| id(PK)             | デフォルト          | null: false             |
| nickname           | devise のデフォルト | null: false,index: true |
| email              | devise のデフォルト | null: false             |
| encrypted_password | integer             | null: false             |
| first_name         | string              | null: false             |
| last_name          | string              | null: false             |
| first_name_kana    | string              | null: false             |
| last_name_kana     | string              | null: false             |
| birth_date         | date                | null: false             |

### Association

* has_many :items
* has_many :item_transactions
* has_many :cards
* has_one :address
* has_many :comments

## addresses table

| Column       | Type    | Options           |
|--------------|---------|-------------------|
| postal_code  | integer | null: false       |
| prefecture   | integer | null: false       |
| city         | string  | null: false       |
| address      | string  | null: false       |
| building     | string  |                   |
| phone_number | string  | null: false       |
| user_id(FK)  | integer | foreign_key: true |

### Association

* belongs_to :user

## items table

| Column                              | Type       | Options           |
|-------------------------------------|------------|-------------------|
| id(PK)                              | デフォルト   | null: false       |
| name                                | string     | null: false       |
| price                               | integer    | null: false       |
| info                                | text       | null: false       |
| scheduled_delivery_id(acitve_hash)  | integer    | null: false       |
| shipping_fee_status_id(acitve_hash) | integer    | null: false       |
| prefecture_id(acitve_hash)          | integer    | null: false       |
| sales_status_id(acitve_hash)        | integer    | null: false       |
| category_id(acitve_hash)            | integer    | null: false       |
| user_id(FK)                         | integer    | foreign_key: true |

### Association

- belongs_to :user
- has_one :item_transaction
- has_many : item_tags
- has_many : tags , through item_tags
* has_many :comments

## item_transactions table

| Column      | Type    | Options           |
|-------------|---------|-------------------|
| item_id(FK) | integer | foreign_key: true |
| user_id(FK) | integer | foreign_key: true |

### Association

- belongs_to :item
- belongs_to :user

## cards table

| Column         | Type    | Options           |
|----------------|---------|-------------------|
| card_token     | string  | null: false       |
| customer_token | string  | null: false       |
| user_id(FK)    | integer | foreign_key: true |

### Association

- belongs_to :user

## tags table

| Column          | Type    | Options                      |
|-----------------|---------|------------------------------|
| tag             | string  | null: false,uniqueness: true |

### Association

- has_many : item_tags
- has_many : items, through item_tags

## item_tags table

| Column      | Type    | Options           |
|-------------|---------|--------------------------------|
| item_id(FK) | integer | foreign_key: true |
| tag_id(FK)  | integer | foreign_key: true |

### Association

- belongs_to : item
- belongs_to : tag

## sns_credential table

| Column      | Type    | Options           |
|-------------|---------|-------------------|
| provider    | string  | null: false       |
| uid         | string  | null: false       |
| user_id(FK) | integer | foreign_key: true |

### Association

- belongs_to : item
- belongs_to : tag

## comment table

| Column      | Type    | Options           |
|-------------|---------|-------------------|
| text        | text    | null: false       |
| item_id(FK) | integer | foreign_key: true |
| user_id(FK) | integer | foreign_key: true |

### Association

- belongs_to : item
- belongs_to : user

## 備考

### 背景色が production で動作しない問題の対処

実際に起きて作業したので、作業ログとして記載させてください。

#### 準備

[1]`background-image: image-url('bg-main-visual-pict_pc.jpg');`のように`image-url`を使用する。

[2]`background-image: image-url('bg-main-visual-pict_pc.jpg');`などの`image-url`を使用しているファイルの拡張子を css から scss に変更。

### heroku の環境変数設定

参考：https://devcenter.heroku.com/articles/config-vars

**一覧表示**
`% heroku config`

**特定の変数を表示**
`% heroku config:get <変数名>`

**変数をセットする**
`% heroku config:set <変数名>=<値>`

**変数を削除する**
`% heroku config:unset <変数名>`

**Railsで使用するは変わらず下記で可能**
`ENV['<変数名>']`
