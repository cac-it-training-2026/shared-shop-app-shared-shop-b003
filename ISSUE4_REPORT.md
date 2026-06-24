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
