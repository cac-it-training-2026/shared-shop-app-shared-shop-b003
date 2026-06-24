package jp.co.sss.shop.controller.client.review;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.validation.BindingResult;

import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.entity.Review;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.ReviewForm;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.repository.ReviewRepository;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

public class ClientReviewControllerTest {

    @InjectMocks
    private ClientReviewController controller;

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private ItemRepository itemRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private HttpSession session;

    @Mock
    private BindingResult result;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testRegistReview_Success() {
        // Arrange
        ReviewForm form = new ReviewForm();
        form.setProductId(1);
        form.setRating(5);
        form.setBody("Great product!");

        UserBean userBean = new UserBean();
        userBean.setId(1);

        when(session.getAttribute("user")).thenReturn(userBean);
        when(result.hasErrors()).thenReturn(false);
        when(itemRepository.findByIdAndDeleteFlag(1, Constant.NOT_DELETED)).thenReturn(new Item());
        when(userRepository.findByIdAndDeleteFlag(1, Constant.NOT_DELETED)).thenReturn(new User());

        // Act
        String viewName = controller.registReview(form, result);

        // Assert
        assertEquals("redirect:/client/item/detail/1", viewName);
        verify(reviewRepository, times(1)).save(any(Review.class));
    }

    @Test
    public void testRegistReview_NoLogin() {
        // Arrange
        ReviewForm form = new ReviewForm();
        when(session.getAttribute("user")).thenReturn(null);

        // Act
        String viewName = controller.registReview(form, result);

        // Assert
        assertEquals("redirect:/login", viewName);
        verify(reviewRepository, never()).save(any(Review.class));
    }
}
