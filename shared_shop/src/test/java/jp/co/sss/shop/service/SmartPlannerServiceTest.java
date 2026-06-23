package jp.co.sss.shop.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Category;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.SmartPlannerService.RecommendedSet;
import jp.co.sss.shop.util.Constant;

@ExtendWith(MockitoExtension.class)
public class SmartPlannerServiceTest {

    @InjectMocks
    private SmartPlannerService smartPlannerService;

    @Mock
    private ItemRepository itemRepository;

    @Mock
    private BeanTools beanTools;

    private List<Item> mockItems;

    @BeforeEach
    void setUp() {
        mockItems = new ArrayList<>();

        Category pcCategory = new Category("PC");
        Item pc = new Item();
        pc.setId(1);
        pc.setName("Gaming PC");
        pc.setPrice(80000);
        pc.setStock(5);
        pc.setCategory(pcCategory);
        mockItems.add(pc);

        Category mouseCategory = new Category("マウス");
        Item mouse = new Item();
        mouse.setId(2);
        mouse.setName("Gaming Mouse");
        mouse.setPrice(5000);
        mouse.setStock(10);
        mouse.setCategory(mouseCategory);
        mockItems.add(mouse);
    }

    @Test
    void testGenerateRecommendedSets_Game() {
        // Arrange
        when(itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED)).thenReturn(mockItems);

        List<ItemBean> mockItemBeans = new ArrayList<>();
        ItemBean pcBean = new ItemBean();
        pcBean.setName("Gaming PC");
        pcBean.setPrice(80000);
        mockItemBeans.add(pcBean);

        ItemBean mouseBean = new ItemBean();
        mouseBean.setName("Gaming Mouse");
        mouseBean.setPrice(5000);
        mockItemBeans.add(mouseBean);

        // シンプルにするため、BeanToolsの動作を一部モック
        when(beanTools.copyEntityListToItemBeanList(anyList())).thenReturn(mockItemBeans);

        // Act
        List<RecommendedSet> sets = smartPlannerService.generateRecommendedSets("ゲーム", 100000);

        // Assert
        assertFalse(sets.isEmpty());
        RecommendedSet set = sets.get(0);
        assertTrue(set.getTotalPrice() <= 100000);
        // 合計金額の計算はService内で行われるが、ItemBeanのリストからではなく、選択されたItemのリストから。
        // モックされたItemは 80000 + 5000 = 85000
        assertEquals(85000, set.getTotalPrice());
    }

    @Test
    void testGenerateRecommendedSets_LowBudget() {
        // Arrange
        when(itemRepository.findByDeleteFlagOrderByInsertDateDesc(Constant.NOT_DELETED)).thenReturn(mockItems);

        List<ItemBean> mockItemBeans = new ArrayList<>();
        ItemBean mouseBean = new ItemBean();
        mouseBean.setName("Gaming Mouse");
        mouseBean.setPrice(5000);
        mockItemBeans.add(mouseBean);

        when(beanTools.copyEntityListToItemBeanList(anyList())).thenReturn(mockItemBeans);

        // Act
        List<RecommendedSet> sets = smartPlannerService.generateRecommendedSets("ゲーム", 10000);

        // Assert
        assertFalse(sets.isEmpty());
        RecommendedSet set = sets.get(0);
        assertEquals(5000, set.getTotalPrice()); // マウスのみ予算内
        assertEquals(1, set.getItems().size());
    }
}
