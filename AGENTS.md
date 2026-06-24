# AGENTS.md

## システム概要

本システムは、JavaおよびSpring Bootで構築されたプログラム教育用の会員制ECサイト（Shared Shop）です。
一般ユーザー（購入者）向けのショッピング機能と、システム管理者・店舗管理者向けのバックオフィス管理機能を備えています。

### 技術構成

* Spring Boot 4.0.6
* Spring MVC
* Spring Data JPA
* Thymeleaf (キャッシュ無効化)
* Oracle Database (ojdbc11 / Oracle 21c Express Edition 想定)
* Bean Validation
* Maven
* Java 17

#### 接続設定
* コンテキストパス: `/shared_shop`
* ポート番号: `55000`

---

## 主な機能

### 1. ユーザー機能 (Client)

#### 会員管理
* 新規会員登録
* ログイン／ログアウト
* 会員情報変更
* 退会

**関連Controller**:
* `ClientUserRegistController`
* `ClientUserShowController`
* `ClientUserUpdateController`
* `ClientUserDeleteController`
* `LoginController`
* `LogoutController`

#### 商品閲覧
* 商品一覧表示
* 商品詳細表示
* カテゴリ別検索
* 人気商品表示

**関連Controller**:
* `ClientItemShowController`

#### カート機能
* 商品をカートへ追加
* カート内商品一覧表示
* 数量変更
* 削除

**関連Controller**:
* `ClientBasketController`

#### 注文機能
* 配送先入力
* 支払い方法入力
* 注文確認
* 注文確定
* 注文履歴表示

**関連Controller**:
* `ClientOrderRegistController`
* `ClientOrderShowController`

---

### 2. 管理者機能 (Admin)

#### 会員管理
* 会員一覧
* 詳細確認
* 新規登録
* 情報更新
* 削除

**関連Controller**:
* `AdminUserShowController`
* `AdminUserRegistController`
* `AdminUserUpdateController`
* `AdminUserDeleteController`

#### 商品管理
* 商品一覧
* 詳細確認
* 新規登録 (画像アップロード対応)
* 情報更新
* 削除

**関連Controller**:
* `AdminItemShowController`
* `AdminItemRegistController`
* `AdminItemUpdateController`
* `AdminItemDeleteController`

#### カテゴリ管理
* カテゴリ一覧
* 新規登録
* 情報更新
* 削除

**関連Controller**:
* `AdminCategoryShowController`
* `AdminCategoryRegistController`
* `AdminCategoryUpdateController`
* `AdminCategoryDeleteController`

#### 注文管理
* 全ユーザーの注文一覧確認
* 注文詳細確認

**関連Controller**:
* `AdminOrderShowController`

---

## データベース構造

主要テーブルは5つです。

| テーブル名 (物理名) | 論理名 | 内容・用途 |
| :--- | :--- | :--- |
| `users` | 会員情報 | 会員データ、権限管理（`authority`）、論理削除フラグ（`deleteFlag`）を保持。 |
| `categories` | 商品カテゴリ | 商品の分類情報を保持。 |
| `items` | 商品情報 | 商品名、価格、在庫、画像ファイル名、カテゴリIDを保持。 |
| `orders` | 注文情報 | 注文日時、配送先、支払方法、注文者IDを保持。 |
| `order_items` | 注文明細 | 1回の注文における商品ごとの数量、購入時価格、注文ID・商品IDを保持。 |

---

## エンティティ関係
User (users)
 └─ Order (orders)
       └─ OrderItem (order_items)
             ├─ Item (items)
             └─ Category (categories)

### 関係

* 1人の会員 → 複数注文 (1:N)
* 1注文 → 複数注文明細 (1:N)
* 1商品 → 複数注文明細 (1:N)
* 1カテゴリ → 複数商品 (1:N)

---

## 基本開発ルール・実装規則

### 1. アーキテクチャと命名規則

機能（Show/Regist/Update/Delete）ごとに細分化された既存のクラス構成を維持すること。

* **Controller**: `jp.co.sss.shop.controller` 配下。画面遷移、Formからの入力受け取り、Viewへのモデルマッピングを担当。
* **Entity**: `jp.co.sss.shop.entity` 配下。JPAアノテーション（`@Entity`, `@Table`, `@Id`等）を使用。主キーはシーケンス（例: `seq_users_gen`）により自動生成。
* **Repository**: `jp.co.sss.shop.repository` 配下。`JpaRepository` を継承。
* **Form**: 画面入力値保持用。
* **Bean**: セッションやDTO用。

### 2. 認証・認可とアクセス制限

Controller内で権限チェックを行わず、`jp.co.sss.shop.filter` 配下のサーブレットフィルタを使用すること。

* `LoginCheckFilter`
* `AdminAccountCheckFilter`
* `ClientAccountCheckFilter`
* `SystemAdminAccountCheckFilter`

### 3. バリデーション

* 単純な入力チェックは Form クラスにアノテーション (`@NotBlank` 等) を付与。
* エラーメッセージは `ValidationMessages.properties` から取得。
* 複合チェックやDB参照が必要なチェックはカスタムアノテーション（`@EmailCheck`, `@LoginCheck`, `@CategoryCheck`, `@ItemCheck` 等）と対応する Validator クラスを使用すること。

### 4. 画面構成 (Thymeleaf)

`templates/common/` 配下の共通レイアウトフラグメント（`layout_3block.html` 等）を使用し、ヘッダー、フッター、サイドメニューを共通化すること。

### 5. データベース操作の注意点

* データ削除は物理削除を行わず、`deleteFlag` カラムを用いた論理削除（`0`:未削除, `1`:削除済み）で実装すること。
* 検索時は原則として `deleteFlag = 0` のデータを対象とすること。

---
# 開発時の禁止事項

* pom.xmlの変更を生じる新たなライブラリの導入は禁止（フロントエンドのCDNはOK）
* サービスレイヤは含まず、基礎的なＭＶＣで構成する（Controllerから直接JPAリポジトリのメソッドを呼んでいる）
* コーディング規約はクラスはUpperキャメル、メソッドはlowerキャメルなど原則、Google Java Styleに準拠する
---
# Julesのルール

* セッション内のやり取り、プルリクエストの内容は日本語で記述して下さい
* 画面に変更がある場合はマルチモーダルで視覚的に示してください
---
