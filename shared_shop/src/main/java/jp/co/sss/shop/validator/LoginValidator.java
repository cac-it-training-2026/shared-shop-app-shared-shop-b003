package jp.co.sss.shop.validator;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;

import jp.co.sss.shop.annotation.LoginCheck;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

/**
 * ログインチェックの独自検証クラス
 *
 * @author System Shared
 */
public class LoginValidator implements ConstraintValidator<LoginCheck, Object> {
	private String email;
	private String password;

	@Autowired
	UserRepository userRepository;

	@Autowired
	HttpSession session;

	@Override
	public void initialize(LoginCheck annotation) {
		this.email = annotation.fieldEmail();
		this.password = annotation.fieldPassword();
	}

	@Override
	public boolean isValid(Object value, ConstraintValidatorContext context) {
		BeanWrapper beanWrapper = new BeanWrapperImpl(value);
		boolean isValidFlg = false;
		String emailProp = (String) beanWrapper.getPropertyValue(this.email);
		String passwordProp = (String) beanWrapper.getPropertyValue(this.password);

		User user = userRepository.findByEmailAndDeleteFlag(emailProp, Constant.NOT_DELETED);

		if (user != null && user.getLockedUntil() != null && user.getLockedUntil().after(new java.sql.Timestamp(System.currentTimeMillis()))) {
			// ロック中の場合は認証失敗とする
			return false;
		}

		if (user != null && passwordProp.equals(user.getPassword())) {
			UserBean userBean = new UserBean();

			userBean.setId(user.getId());
			userBean.setName(user.getName());
			userBean.setAuthority(user.getAuthority());
			userBean.setRole(user.getRole());
			userBean.setGachaCount(user.getGachaCount());

			// テーマ設定
			int themeId = (user.getThemeId() == null) ? 0 : user.getThemeId();
			if (themeId >= 0 && themeId < Constant.THEME_CLASSES.length) {
				userBean.setThemeClass(Constant.THEME_CLASSES[themeId]);
			} else {
				userBean.setThemeClass(Constant.THEME_CLASSES[0]);
			}

			// セッションスコープにログインしたユーザの情報を登録
			session.setAttribute("user", userBean);
			isValidFlg = true;
		} else {
			//ユーザ認証に失敗
			isValidFlg = false;
		}
		return isValidFlg;
	}
}
