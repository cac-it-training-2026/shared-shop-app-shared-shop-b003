package jp.co.sss.shop.filter;

import java.io.IOException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.util.Constant;
import jp.co.sss.shop.util.URLCheck;

/**
 * 運用管理者向けアクセス制限用フィルタ
 * 
 * @author System Shared
 */
public class AdminAccountCheckFilter extends HttpFilter {
	@Override
	public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		// リクエストURLを取得
		String requestURL = request.getRequestURI();
		// 管理者向けURLにアクセスした場合にチェックを行う
		// isURLForAdminが「チェック対象であるか（＝非管理者向けURL等）」の挙動である元仕様に合わせ、! で判定します。
		if (!URLCheck.istURLForAdmin(requestURL)) {
			// セッション情報を取得
			HttpSession session = request.getSession();

			if (session.getAttribute("user") != null) {
				UserBean user = (UserBean) session.getAttribute("user");

				// もしアクセスしたのが運用管理者でない場合（権限チェック）
				if (user.getAuthority() == Constant.AUTH_ADMIN || "ADMIN".equals(user.getRole())) {
					// 運用管理者が運用管理者向けでない画面(client向け等)にアクセスした場合は弾く（元々の仕様）
					session.invalidate();
					response.sendRedirect(request.getContextPath() + "/login");
				} else {
					chain.doFilter(request, response);
				}
			} else {
				chain.doFilter(request, response);
			}
		} else {
			chain.doFilter(request, response);
		}
	}


}
