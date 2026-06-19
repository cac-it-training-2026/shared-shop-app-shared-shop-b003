# 追加機能の仕様と実装規約 (ISSUE_SPECS.md)

本ドキュメントは、新たに実装する以下の機能についての仕様とデータベースの変更点・規約を定義するものです。

## 1. 権限分離とアカウントロック機能 (Issue #4, #5)

### 仕様概要
- 管理者（ADMIN）と一般ユーザー（USER）の権限を分離し、`/admin/` 以下のパスへのアクセスを制御する。
- ブルートフォース攻撃対策として、連続して5回ログインに失敗した場合、アカウントを15分間ロックする。

### テーブルの変更 (users)
- `role`: 管理者と一般の区分（既存の `authority` と併用するか置き換える形となるが、今回は追加の権限管理を考慮する）。
- `failed_login_count`: ログイン失敗回数 (integer, デフォルト0)。
- `locked_until`: アカウントロック解除日時 (timestamp)。

## 2. 最近見た商品 (Issue #2)

### 仕様概要
- ユーザーが詳細画面を閲覧した商品の履歴（最新5件）を画面サイドバーに表示する。
- ログイン状況にかかわらずセッションで一時的に保持する。

### データ管理
- サーバーサイドの HTTP Session (属性名: `recentlyViewedItems`) を使用し、データベースの変更は行わない。

## 3. 商品レビュー機能 (Issue #6, #8)

### 仕様概要
- ユーザーが各商品に対して、5段階評価とテキスト(最大500文字)でレビューを投稿・閲覧できる。
- 商品詳細画面にて、平均評価とレビュー一覧を表示する。

### 新規テーブル (reviews)
- `id`: レビューID (PK, Sequence)
- `product_id`: 対象商品のID (FK)
- `user_id`: 投稿したユーザーのID (FK)
- `rating`: 1〜5の評価値 (integer)
- `comment`: テキスト本文 (varchar 500)
- `created_time`: 投稿日時 (timestamp)

## 4. クーポン機能 (Issue #7)

### 仕様概要
- カート・注文画面において、クーポンコードを入力することで割引を適用する。
- 割引には金額指定（固定額オフ）と割合指定（%オフ）の2種類が存在する。

### テーブルの変更 (orders)
- `discount_amount`: 適用されたクーポンによる割引額 (integer)

### 新規テーブル (coupons)
- `id`: クーポンID (PK, Sequence)
- `code`: クーポンコード (varchar, UNIQUE)
- `discount_type`: "amount" または "percent" (varchar)
- `discount_value`: 割引値 (integer)
- `valid_from`: 有効開始日時 (timestamp)
- `valid_until`: 有効終了日時 (timestamp)
- `usage_limit`: 最大利用回数 (integer)
- `created_by`: 作成した管理者のID (integer)

## 5. ガチャ機能 (Issue #10)

### 仕様概要
- ログイン成功時や注文完了時に、ガチャを回すイベントが発生し、ランダムでクーポンが付与される。

### 新規テーブル (gacha_logs)
- `id`: ガチャログID (PK, Sequence)
- `user_id`: ユーザーID (FK)
- `event_type`: "login" または "order" (varchar)
- `outcome`: "win" または "lose" (varchar)
- `coupon_id`: 当選した場合のクーポンID (FK, nullable)
- `created_at`: 実行日時 (timestamp)
