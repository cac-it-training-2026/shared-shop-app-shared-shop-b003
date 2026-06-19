# 現状の課題（Issue）一覧

リポジトリ内（main, dev, feedbackブランチ）の調査により特定された課題の一覧です。

## 1. 機能改修
### 売れ筋商品の表示機能の実装
*   **対象**: `shared_shop/src/main/java/jp/co/sss/shop/controller/client/item/ClientItemShowController.java`
*   **内容**: トップ画面の商品表示を「注文回数が多い順（売れ筋順）」に表示するよう改修する。
*   **ブランチ**: `feedback` でTODOとして記載。

## 2. 設定・セキュリティ
### フィルター制限の有効化
*   **対象**: `shared_shop/src/main/java/jp/co/sss/shop/config/FilterConfig.java`
*   **内容**: 開発用に無効化されているアクセス制限フィルターを適切に設定・有効化する。
*   **ブランチ**: 全ブランチ共通。

## 3. バリデーション・国際化
### バリデーションエラーメッセージの定義
*   **対象**: `shared_shop/src/main/resources/ValidationMessages.properties`
*   **内容**: 各種バリデーション制約（NotBlank, Size等）のメッセージを「TODO」から適切な日本語に修正する。
*   **ブランチ**: `feedback` でTODOとして記載。

## 4. 例外処理
### 会員登録時の例外ハンドリングの実装
*   **対象**: `shared_shop/src/main/java/jp/co/sss/shop/controller/client/user/ClientUserRegistController.java`
*   **内容**: `showUserRegistComplete` メソッドでの例外発生時のハンドリングを実装する。
*   **ブランチ**: `main`, `dev` でTODOとして記載。
