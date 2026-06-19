package jp.co.sss.shop.controller.login;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.sql.Timestamp;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import jakarta.servlet.http.HttpSession;
import jp.co.sss.shop.bean.UserBean;
import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

@SpringBootTest
@AutoConfigureMockMvc
public class LoginControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserRepository userRepository;

    private User user;

    @BeforeEach
    public void setup() {
        user = new User();
        user.setId(1);
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setRole(Constant.ROLE_USER);
        user.setFailedLoginCount(0);
        user.setDeleteFlag(Constant.NOT_DELETED);
    }

    @Test
    public void testDoLogin_LockAccountAfter5Failures() throws Exception {
        when(userRepository.findByEmailAndDeleteFlag(anyString(), anyInt())).thenReturn(user);

        // Fail 5 times
        for (int i = 0; i < 5; i++) {
            mockMvc.perform(post("/login")
                    .param("email", "test@example.com")
                    .param("password", "wrongpassword"))
                    .andExpect(status().isOk())
                    .andExpect(view().name("login"));
        }

        verify(userRepository, times(5)).save(any(User.class));
        assert user.getFailedLoginCount() == 5;
        assert user.getLockedUntil() != null;
    }

    @Test
    public void testDoLogin_ResetFailureCountOnSuccess() throws Exception {
        user.setFailedLoginCount(3);
        when(userRepository.findByEmailAndDeleteFlag(anyString(), anyInt())).thenReturn(user);
        when(userRepository.getReferenceById(anyInt())).thenReturn(user);

        UserBean userBean = new UserBean();
        userBean.setId(1);
        userBean.setRole(Constant.ROLE_USER);

        mockMvc.perform(post("/login")
                .param("email", "test@example.com")
                .param("password", "password123")
                .sessionAttr("user", userBean))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        assert user.getFailedLoginCount() == 0;
        assert user.getLockedUntil() == null;
    }
}
