package jp.co.sss.shop.controller.client.item;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.junit.jupiter.api.BeforeEach;
import org.mockito.ArgumentCaptor;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.ui.Model;

import jp.co.sss.shop.bean.ItemBean;
import jp.co.sss.shop.entity.Item;
import jp.co.sss.shop.repository.ItemRepository;
import jp.co.sss.shop.service.BeanTools;
import jp.co.sss.shop.util.Constant;

public class ClientItemShowControllerTest {

    @InjectMocks
    private ClientItemShowController controller;

    @Mock
    private ItemRepository itemRepository;

    @Mock
    private BeanTools beanTools;

    @Mock
    private HttpSession session;

    @Mock
    private Model model;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testShowItemAddsToRecentlyViewed() {
        // Arrange
        int itemId = 1;
        Item item = new Item();
        item.setId(itemId);
        ItemBean itemBean = new ItemBean();
        itemBean.setId(itemId);
        itemBean.setName("Test Item");

        when(itemRepository.findByIdAndDeleteFlag(itemId, Constant.NOT_DELETED)).thenReturn(item);
        when(beanTools.copyEntityToItemBean(item)).thenReturn(itemBean);

        when(session.getAttribute("recentlyViewedItems")).thenReturn(null);

        // Act
        String viewName = controller.showItem(itemId, model);

        // Assert
        assertEquals("client/item/detail", viewName);
        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<ItemBean>> captor = ArgumentCaptor.forClass(List.class);
        verify(session).setAttribute(eq("recentlyViewedItems"), captor.capture());

        List<ItemBean> resultList = captor.getValue();
        assertEquals(1, resultList.size());
        assertEquals(itemId, resultList.get(0).getId());
    }

    @Test
    public void testRecentlyViewedDuplicatesAndLimit() {
        // Arrange
        int itemId = 6;
        Item item = new Item();
        item.setId(itemId);
        ItemBean itemBean = new ItemBean();
        itemBean.setId(itemId);
        itemBean.setName("Item 6");

        when(itemRepository.findByIdAndDeleteFlag(itemId, Constant.NOT_DELETED)).thenReturn(item);
        when(beanTools.copyEntityToItemBean(item)).thenReturn(itemBean);

        List<ItemBean> recentlyViewed = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            ItemBean bean = new ItemBean();
            bean.setId(i);
            bean.setName("Item " + i);
            recentlyViewed.add(bean);
        }

        when(session.getAttribute("recentlyViewedItems")).thenReturn(recentlyViewed);

        // Act
        controller.showItem(itemId, model);

        // Assert
        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<ItemBean>> captor = ArgumentCaptor.forClass(List.class);
        verify(session).setAttribute(eq("recentlyViewedItems"), captor.capture());

        List<ItemBean> resultList = captor.getValue();
        assertEquals(5, resultList.size());
        assertEquals(itemId, resultList.get(0).getId());
    }
}
