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

		// 一般会員用URLのチェックが必要な場合はここに追加するが、
		// 現状は全ユーザー(ADMIN, USER)が一般画面を見れる想定
		chain.doFilter(request, response);

	}


}
