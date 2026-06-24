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
			// アカウントロックの確認
			if (user.getLockedUntil() != null && user.getLockedUntil().after(new java.sql.Timestamp(System.currentTimeMillis()))) {
				// アカウントがロックされている
				context.disableDefaultConstraintViolation();
				context.buildConstraintViolationWithTemplate("{login.locked.message}").addConstraintViolation();
				return false;
			}

			if (passwordProp.equals(user.getPassword())) {
				// 認証成功
				UserBean userBean = new UserBean();
				userBean.setId(user.getId());
				userBean.setName(user.getName());
				userBean.setAuthority(user.getAuthority());

				// 失敗回数のリセット
				user.setFailedLoginCount(0);
				user.setLockedUntil(null);
				userRepository.save(user);

				// セッションスコープにログインしたユーザの情報を登録
				session.setAttribute("user", userBean);
				isValidFlg = true;
			} else {
				// 認証失敗
				int count = (user.getFailedLoginCount() != null ? user.getFailedLoginCount() : 0) + 1;
				user.setFailedLoginCount(count);
				if (count >= 5) {
					// 5回失敗で15分間ロック
					user.setLockedUntil(new java.sql.Timestamp(System.currentTimeMillis() + 15 * 60 * 1000));
				}
				userRepository.save(user);
				isValidFlg = false;
			}
		} else {
			// ユーザが存在しない
			isValidFlg = false;
		}
		return isValidFlg;
	}
}
