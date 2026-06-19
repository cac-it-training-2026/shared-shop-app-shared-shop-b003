package jp.co.sss.shop.bean;

/**
 * 会員情報クラス
 *
 * @author SystemShared
 */
public class UserBean {
	/**
	 * 会員ID
	 */
	private Integer id;
	/**
	 * 会員メールアドレス
	 */
	private String email;
	/**
	 * パスワード
	 */
	private String password;
	/**
	 * 会員名
	 */
	private String name;
	/**
	 * 郵便番号
	 */
	private String postalCode;
	/**
	 * 住所
	 */
	private String address;
	/**
	 * 電話番号
	 */
	private String phoneNumber;
	/**
	 * 権限
	 */
	private Integer authority;

	/**
	 * テーマID
	 */
	private Integer themeId;

	/**
	 * 購入回数
	 */
	private Integer purchaseCount;

	/**
	 * 累計購入金額
	 */
	private Integer totalPurchaseAmount;

	/**
	 * テーマクラス名
	 */
	private String themeClass;

	/**
	 * 会員IDの取得
	 * @return 会員ID
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * 会員IDのセット
	 * @param id 会員ID
	 */
	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 会員メールアドレスの取得
	 * @return 会員メールアドレス
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * 会員メールアドレスのセット
	 * @param email 会員メールアドレス
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * パスワードの取得
	 * @return パスワード
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * パスワードのセット
	 * @param password パスワード
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * 会員氏名の取得
	 * @return 会員氏名
	 */
	public String getName() {
		return name;
	}

	/**
	 * 会員氏名のセット
	 * @param name 会員氏名
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 郵便番号の取得
	 * @return 郵便番号
	 */
	public String getPostalCode() {
		return postalCode;
	}

	/**
	 * 郵便番号のセット
	 * @param postalCode 郵便番号
	 */
	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

	/**
	 * 住所の取得
	 * @return 住所
	 */
	public String getAddress() {
		return address;
	}

	/**
	 * 住所のセット
	 * @param address 住所
	 */
	public void setAddress(String address) {
		this.address = address;
	}

	/**
	 * 電話番号の取得
	 * @return 電話番号
	 */
	public String getPhoneNumber() {
		return phoneNumber;
	}

	/**
	 * 電話番号のセット
	 * @param phoneNumber 電話番号
	 */
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	/**
	 * 権限の取得
	 * @return 権限
	 */
	public Integer getAuthority() {
		return authority;
	}

	/**
	 * 権限のセット
	 * @param authority 権限
	 */
	public void setAuthority(Integer authority) {
		this.authority = authority;
	}

	/**
	 * テーマIDの取得
	 * @return テーマID
	 */
	public Integer getThemeId() {
		return themeId;
	}

	/**
	 * テーマIDのセット
	 * @param themeId テーマID
	 */
	public void setThemeId(Integer themeId) {
		this.themeId = themeId;
	}

	/**
	 * 購入回数の取得
	 * @return 購入回数
	 */
	public Integer getPurchaseCount() {
		return purchaseCount;
	}

	/**
	 * 購入回数のセット
	 * @param purchaseCount 購入回数
	 */
	public void setPurchaseCount(Integer purchaseCount) {
		this.purchaseCount = purchaseCount;
	}

	/**
	 * 累計購入金額の取得
	 * @return 累計購入金額
	 */
	public Integer getTotalPurchaseAmount() {
		return totalPurchaseAmount;
	}

	/**
	 * 累計購入金額のセット
	 * @param totalPurchaseAmount 累計購入金額
	 */
	public void setTotalPurchaseAmount(Integer totalPurchaseAmount) {
		this.totalPurchaseAmount = totalPurchaseAmount;
	}

	/**
	 * テーマクラス名の取得
	 * @return テーマクラス名
	 */
	public String getThemeClass() {
		return themeClass;
	}

	/**
	 * テーマクラス名のセット
	 * @param themeClass テーマクラス名
	 */
	public void setThemeClass(String themeClass) {
		this.themeClass = themeClass;
	}

}
