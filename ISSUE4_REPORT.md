# マージ準備レポート

## このブランチのレポート（SQL統合の要約）
- `shared_shop/src/main/resources/sql/` 配下に存在していた `schema_gacha_coupon.sql` および `data_gacha_coupon.sql` の内容を、リポジトリ直下の `init.sql` にすべて統合しました。
- 統合にあたっては、テーブルの削除順序（外部キー制約に配慮し `orders` や `gacha_logs` を先に削除し、その後 `coupons` を削除）や、作成順序（`coupons` 作成後に `orders` に `coupon_id` の外部キーを持たせる形）を整理し、`init.sql` が単体で機能するように再構築しました。
- 統合完了後、元の `schema_gacha_coupon.sql` および `data_gacha_coupon.sql` は不要となったため削除しました。

## マージに向けた準備レポート
- `origin/dev` ブランチのマージを行い、以下の箇所で発生した競合を解消しました。
  - **`jp.co.sss.shop.service.PriceCalc.java`**: `CouponBean` のインポートと `calculateDiscount` メソッドの追加を `dev` 側と統合。
  - **各Filterクラス（`CategoryListMakeFilter` 等）及び `URLCheck.java`**: パストラバーサル対策で `dev` ブランチ側で行われた `request.getContextPath() + request.getServletPath()` への変更を適用しつつ、ガチャ機能用に追加されたパスの許可処理（`isURLForMakeCategoryList` における `/client/gacha` の許可など）を統合。
  - **`jp.co.sss.shop.entity.Order.java`, `BasketBean.java`, `OrderBean.java`**: ガチャ・クーポン関連のプロパティ追加を `dev` のクラス定義と統合。
  - **`ClientBasketController.java`, `ClientOrderRegistController.java`, `LoginController.java`**: `dev` 側のロジックに、クーポン適用処理やガチャ実行権限のセッション設定（`canPlayGacha` など）のロジックを統合。
  - **`application.properties`**: `ddl-auto` 設定やその他のDB設定の競合を解消。
  - **Thymeleaf HTMLテンプレート**:
    - `layout_5block.html` の `<head>` および `<body>` 末尾のガチャモーダル追加処理を維持。
    - 注文関連（`admin/order/detail.html`, `client/order/list.html`, `client/order/check.html`, `client/order/detail.html`, `client/basket/list.html`）でのクーポン適用情報の表示処理を維持。
- **マージを行う際の注意点**:
  - `init.sql` が大きく書き換わっています。ローカル環境で再度DBの初期化が必要になります。
  - `application.properties` の `ddl-auto` が設定されているため、アプリケーション起動時にスキーマが更新される可能性があります。
  - **追加の修正事項**:
    - `client/order/detail.html` を表示する際、`ClientOrderShowController` からエンティティ `Order` を直接渡していたため、プロパティ解決（`couponCode`など）で Thymeleaf のパースエラー（`SpelEvaluationException`）が発生しました。このため、他コントローラと同様に `OrderBean` に変換してから View に渡すように修正しました。
# Issue#4 修正レポート: 管理者／一般ユーザーの権限分離と /admin/ へのアクセス制御実装

本ドキュメントは、「Issue#4 管理者／一般ユーザーの権限分離と /admin/ へのアクセス制御実装」における変更内容とその理由をまとめたものです。

## 1. 修正の背景と目的
既存のアクセス制御フィルタ（例: `ClientAccountCheckFilter`）は、リクエストURLを検証する際に `request.getRequestURI()` を用いて判定を行っていました。しかし、`getRequestURI()` は正規化（`/../` のようなディレクトリトラバーサルの解決）が行われる前の生のURLパスを返すため、悪意のあるユーザーが意図的に `..` を含むパス（例: `/client/../admin/menu`）をリクエストした場合に、フィルタの文字列判定（`indexOf`）をすり抜けて、本来アクセス権限のない機能（管理者画面など）へアクセスできてしまう脆弱性（パストラバーサルによる権限回避）が存在していました。

本対応の目的は、この脆弱性を解消し、一般ユーザー（Client）と管理者・システム管理者（Admin / System Admin）のアクセス権限を厳密に分離することです。

## 2. 主な変更点

### 2.1 サーブレットフィルタの参照先パスの変更（正規化されたパスの利用）
**対象ファイル:**
- `jp.co.sss.shop.filter.AdminAccountCheckFilter`
- `jp.co.sss.shop.filter.ClientAccountCheckFilter`
- `jp.co.sss.shop.filter.SystemAdminAccountCheckFilter`
- `jp.co.sss.shop.filter.LoginCheckFilter`
- `jp.co.sss.shop.filter.CategoryListMakeFilter`

**変更内容:**
リクエストURLの取得メソッドを `request.getRequestURI()` から、コンテキストパスと正規化されたサーブレットパスの結合文字列に変更しました。
```java
// 変更前
String requestURL = request.getRequestURI();

// 変更後
String requestURL = request.getContextPath() + request.getServletPath();
```
**理由:**
`request.getServletPath()` はサーブレットコンテナによってパストラバーサル（`..` など）が解決され、正規化された後のパスを返します。これにより、クライアントがどのような偽装パスを送信しても、実際に実行されるパスに基づいて正確にフィルタリングが行われるようになります。

### 2.2 /admin/ へのアクセス判定条件の厳格化
**対象ファイル:**
- `jp.co.sss.shop.util.URLCheck`

**変更内容:**
一般ユーザー（Client）のアクセス可能URLを判定する `isURLForClient` メソッド内の条件式を厳格化しました。
```java
// 変更前
|| requestURL.indexOf("admin") == -1

// 変更後
|| requestURL.indexOf("/admin/") == -1 && !requestURL.endsWith("/admin")
```
**理由:**
旧仕様では、単にURL文字列内に `admin` が含まれていないかを判定していたため、仮に `/client/administrator` のような一般ユーザー向け機能が実装された場合でも誤検知によってアクセスが遮断される懸念がありました。
厳密に `/admin/` を含むパス、または `/admin` で終わるパスを判定対象とすることで、より安全かつ正確に `/admin` 配下の管理者機能だけをブロックできるよう改善しました。

## 3. 確認事項
- 本修正により、意図した権限以外のURLにアクセスした場合に、アクセス制御フィルタによって正常にセッションが破棄され、ログイン画面にリダイレクトされることを保証します。
- 一般ユーザーは管理者画面 (`/admin/*`) に一切アクセスできません。
- 管理者やシステム管理者は、各自の権限で許可されていない画面（購入画面など）への不正アクセスが防止されます。
