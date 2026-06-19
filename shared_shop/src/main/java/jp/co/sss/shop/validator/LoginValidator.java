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

		if (user != null) {
			// ロック状態の確認 (現在時刻よりロック解除時刻が未来の場合)
			java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
			if (user.getLockedUntil() != null && user.getLockedUntil().after(now)) {
				// アカウントがロックされている
				context.disableDefaultConstraintViolation();
				context.buildConstraintViolationWithTemplate("{login.locked.message}").addConstraintViolation();
				return false;
			}

			if (passwordProp.equals(user.getPassword())) {
				UserBean userBean = new UserBean();

				userBean.setId(user.getId());
				userBean.setName(user.getName());
				userBean.setAuthority(user.getAuthority());
				userBean.setRole(user.getRole());

				// セッションスコープにログインしたユーザの情報を登録
				session.setAttribute("user", userBean);
				isValidFlg = true;
			} else {
				// パスワードが不一致の場合
				isValidFlg = false;
			}
		} else {
			//ユーザ認証に失敗
			isValidFlg = false;
		}
		return isValidFlg;
	}
}
