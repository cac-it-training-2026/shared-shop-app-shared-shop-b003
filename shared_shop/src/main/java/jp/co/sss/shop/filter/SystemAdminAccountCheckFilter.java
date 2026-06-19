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

		// ADMINロールのチェックに集約されるため、個別のチェックは不要
		chain.doFilter(request, response);
	}


}
