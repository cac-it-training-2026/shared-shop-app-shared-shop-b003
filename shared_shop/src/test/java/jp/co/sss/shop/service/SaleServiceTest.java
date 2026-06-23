package jp.co.sss.shop.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.SaleSchedule;
import jp.co.sss.shop.repository.SaleScheduleRepository;
import jp.co.sss.shop.util.Constant;

@ExtendWith(MockitoExtension.class)
public class SaleServiceTest {

    @Mock
    private SaleScheduleRepository saleScheduleRepository;

    @InjectMocks
    private SaleService saleService;

    private List<SaleSchedule> sales;

    @BeforeEach
    public void setUp() {
        sales = new ArrayList<>();

        Category food = new Category();
        food.setId(1);

        SaleSchedule foodSale = new SaleSchedule();
        foodSale.setCategory(food);
        foodSale.setStartTime(LocalTime.of(12, 0));
        foodSale.setEndTime(LocalTime.of(14, 0));
        foodSale.setDiscountRate(20);
        foodSale.setDeleteFlag(Constant.NOT_DELETED);

        sales.add(foodSale);
    }

    @Test
    public void testGetActiveSales_Safe() {
        lenient().when(saleScheduleRepository.findByDeleteFlag(Constant.NOT_DELETED)).thenReturn(sales);
        saleService.getActiveSales();
    }

    @Test
    public void testApplyDiscount() {
        SaleSchedule sale = sales.get(0);
        Map<Integer, SaleSchedule> activeSales = Map.of(1, sale);

        ItemBean item = new ItemBean();
        item.setCategoryId(1);
        item.setPrice(1000);
        item.setCategoryName("食品");

        saleService.applyDiscount(item, activeSales);

        assertEquals(800, item.getDiscountedPrice());
        assertEquals(20, item.getDiscountRate());
    }

    @Test
    public void testGetRemainingTime() {
        SaleSchedule sale = sales.get(0);
        String remaining = saleService.getRemainingTime(sale);
        assertNotNull(remaining);
    }
}
