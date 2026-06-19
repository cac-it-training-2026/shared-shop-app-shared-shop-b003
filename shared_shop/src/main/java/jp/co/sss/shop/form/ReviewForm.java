package jp.co.sss.shop.form;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * レビュー入力用フォーム
 */
public class ReviewForm {

	@NotNull
	private Integer productId;

	@NotNull
	@Min(1)
	@Max(5)
	private Integer rating;

	@NotBlank
	@Size(max = 1000)
	private String body;

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public Integer getRating() {
		return rating;
	}

	public void setRating(Integer rating) {
		this.rating = rating;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}
}
