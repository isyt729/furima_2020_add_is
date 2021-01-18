class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  # <<バリデーション>>
  # 疑問：なぜユーザ名の大文字小文字を分けて登録できるようにするのか？一意性に関しては必須機能で言及されていない
  # 想定される質問：「なぜmailアドレスのバリデーションは必要ないんですか？また、テストは書かなければいけないのですか？」
  # →デフォルトで実装されているが、変更することもできるため、変更されていないことを確認するためにテストは必要
  validates :nickname, presence: true, uniqueness: { case_sensitive: true }
  validates :birth_date, presence: true

  # パスワードの英数字混在を否定
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'は半角英数字混合にしてください'

  # 全角のひらがなor漢字を使用していないか検証
  with_options presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角日本語で入力してください' } do
    validates :first_name
    validates :last_name
  end

  # 全角のカタカナを使用していないか検証
  with_options presence: true, format: { with: /\A[\p{katakana}　ー－&&[^ -~｡-ﾟ]]+\z/, message: 'は全角カナで入力してください' } do
    validates :first_name_kana
    validates :last_name_kana
  end

  # <<アソシエーション>>
  has_many :items
  has_many :item_transactions
  has_one :card, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :sns_credentials
  has_many :comments

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = User.where(email: auth.info.email).first_or_initialize(
     nickname: auth.info.name,
       email: auth.info.email
   )
   # userが登録済みの場合はそのままログインの処理へ行くので、ここでsnsのuser_idを更新しておく
   if user.persisted?
     sns.user = user
     sns.save
   end
   { user: user, sns: sns }
  end
end
