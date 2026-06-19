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
 * 一般会員向けアクセス制限用フィルタ
 * 
 * @author System Shared
 */

public class ClientAccountCheckFilter extends HttpFilter {
	@Override
	public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		// リクエストURLを取得
		String requestURL = request.getRequestURI();
		
		// 一般会員向けURLでない場合（管理者向けなど）にチェックを行う
		if (!URLCheck.isURLForClient(requestURL,request.getContextPath())) {
			// セッション情報を取得
			HttpSession session = request.getSession();

			if (session.getAttribute("user") != null) {
				UserBean user = (UserBean) session.getAttribute("user");

				// 一般会員が一般会員向けでないURLにアクセスした場合に弾く
				if (user.getAuthority() == Constant.AUTH_CLIENT || "USER".equals(user.getRole())) {
					// セッション情報を削除
					session.invalidate();

					// ログイン画面にリダイレクト
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
