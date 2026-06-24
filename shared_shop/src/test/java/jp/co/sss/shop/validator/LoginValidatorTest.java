package jp.co.sss.shop.validator;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.sql.Timestamp;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.ConstraintValidatorContext.ConstraintViolationBuilder;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import jp.co.sss.shop.entity.User;
import jp.co.sss.shop.form.LoginForm;
import jp.co.sss.shop.repository.UserRepository;
import jp.co.sss.shop.util.Constant;

class LoginValidatorTest {

    @Mock
    UserRepository userRepository;

    @Mock
    HttpSession session;

    @Mock
    ConstraintValidatorContext context;

    @Mock
    ConstraintViolationBuilder builder;

    @InjectMocks
    LoginValidator loginValidator;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        // LoginValidator uses reflection to get properties, so we need to set the fields
        loginValidator.initialize(new jp.co.sss.shop.annotation.LoginCheck() {
            @Override
            public Class<? extends java.lang.annotation.Annotation> annotationType() { return jp.co.sss.shop.annotation.LoginCheck.class; }
            @Override
            public String message() { return "{login.missing.message}"; }
            @Override
            public Class<?>[] groups() { return new Class<?>[]{}; }
            @Override
            public Class<? extends jakarta.validation.Payload>[] payload() { return new Class[]{}; }
            @Override
            public String fieldEmail() { return "email"; }
            @Override
            public String fieldPassword() { return "password"; }
        });
    }

    @Test
    void testSuccessfulLoginResetsCount() {
        User user = new User();
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setFailedLoginCount(3);
        user.setLockedUntil(null);

        when(userRepository.findByEmailAndDeleteFlag("test@example.com", Constant.NOT_DELETED)).thenReturn(user);

        LoginForm form = new LoginForm();
        form.setEmail("test@example.com");
        form.setPassword("password123");

        boolean result = loginValidator.isValid(form, context);

        assertTrue(result);
        assertEquals(0, user.getFailedLoginCount());
        assertNull(user.getLockedUntil());
        verify(userRepository).save(user);
    }

    @Test
    void testFailedLoginIncrementsCount() {
        User user = new User();
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setFailedLoginCount(0);

        when(userRepository.findByEmailAndDeleteFlag("test@example.com", Constant.NOT_DELETED)).thenReturn(user);

        LoginForm form = new LoginForm();
        form.setEmail("test@example.com");
        form.setPassword("wrongpassword");

        boolean result = loginValidator.isValid(form, context);

        assertFalse(result);
        assertEquals(1, user.getFailedLoginCount());
        assertNull(user.getLockedUntil());
        verify(userRepository).save(user);
    }

    @Test
    void testAccountLockoutAfterFiveFailures() {
        User user = new User();
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setFailedLoginCount(4);

        when(userRepository.findByEmailAndDeleteFlag("test@example.com", Constant.NOT_DELETED)).thenReturn(user);

        LoginForm form = new LoginForm();
        form.setEmail("test@example.com");
        form.setPassword("wrongpassword");

        boolean result = loginValidator.isValid(form, context);

        assertFalse(result);
        assertEquals(5, user.getFailedLoginCount());
        assertNotNull(user.getLockedUntil());
        assertTrue(user.getLockedUntil().after(new Timestamp(System.currentTimeMillis())));
        verify(userRepository).save(user);
    }

    @Test
    void testLoginAttemptWhileLocked() {
        User user = new User();
        user.setEmail("test@example.com");
        user.setPassword("password123");
        user.setLockedUntil(new Timestamp(System.currentTimeMillis() + 15 * 60 * 1000));

        when(userRepository.findByEmailAndDeleteFlag("test@example.com", Constant.NOT_DELETED)).thenReturn(user);
        when(context.buildConstraintViolationWithTemplate(anyString())).thenReturn(builder);

        LoginForm form = new LoginForm();
        form.setEmail("test@example.com");
        form.setPassword("password123");

        boolean result = loginValidator.isValid(form, context);

        assertFalse(result);
        verify(context).disableDefaultConstraintViolation();
        verify(context).buildConstraintViolationWithTemplate("{login.locked.message}");
    }
}
