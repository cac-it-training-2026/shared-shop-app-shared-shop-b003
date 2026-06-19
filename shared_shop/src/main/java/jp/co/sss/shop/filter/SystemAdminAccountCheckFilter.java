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
 * システム管理者向けアクセス制限用フィルタ
 * 
 * @author System Shared
 */

public class SystemAdminAccountCheckFilter extends HttpFilter {
	@Override
	public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		// リクエストURLを取得
		String requestURL = request.getRequestURI();

		if (!URLCheck.isURLForSystemAdmin(requestURL)) {
			// セッション情報を取得
			HttpSession session = request.getSession();

			if (session.getAttribute("user") != null) {
				UserBean user = (UserBean) session.getAttribute("user");

				// システム管理者権限のチェック
				if (user.getAuthority() != Constant.AUTH_SYSTEM && !"SYSTEM_ADMIN".equals(user.getRole())) {
					// アクセス権がない場合はセッション情報を削除してログイン画面にリダイレクト
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
