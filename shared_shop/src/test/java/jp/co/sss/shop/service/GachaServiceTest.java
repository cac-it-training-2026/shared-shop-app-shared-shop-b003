package jp.co.sss.shop.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import jp.co.sss.shop.entity.Coupon;
import jp.co.sss.shop.entity.GachaLog;
import jp.co.sss.shop.repository.CouponRepository;
import jp.co.sss.shop.repository.GachaLogRepository;

@ExtendWith(MockitoExtension.class)
public class GachaServiceTest {

    @Mock
    private CouponRepository couponRepository;

    @Mock
    private GachaLogRepository gachaLogRepository;

    @InjectMocks
    private GachaService gachaService;

    @BeforeEach
    public void setUp() {
    }

    @Test
    public void testPlayGacha_RateLimit() {
        // 過去1分間に5回のログがある状態をシミュレート
        List<GachaLog> logs = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            logs.add(new GachaLog());
        }
        when(gachaLogRepository.findByUserIdAndCreatedAtAfter(anyInt(), any(Timestamp.class)))
            .thenReturn(logs);

        Coupon result = gachaService.playGacha(1, "login", null, "127.0.0.1");

        assertNull(result, "レート制限がかかる場合はnullが返るべき");
        verify(gachaLogRepository, never()).save(any(GachaLog.class));
    }

    @Test
    public void testPlayGacha_Success() {
        // ログなし
        when(gachaLogRepository.findByUserIdAndCreatedAtAfter(anyInt(), any(Timestamp.class)))
            .thenReturn(new ArrayList<>());

        // クーポン保存のモック
        when(couponRepository.save(any(Coupon.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // 確率は10%なので、何度か試行して当選することを確認（ユニットテストとしては確率依存は良くないが、簡易的に）
        // 実際にはGachaServiceのRandomをモック化するか、シードを固定できるようにするのが望ましいが、
        // 今回は実装を最小限に留める。

        // 当選・落選に関わらずログが保存されることを確認
        gachaService.playGacha(1, "login", null, "127.0.0.1");
        verify(gachaLogRepository, times(1)).save(any(GachaLog.class));
    }
}
