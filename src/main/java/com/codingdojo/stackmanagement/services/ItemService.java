package com.codingdojo.stackmanagement.services;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.codingdojo.stackmanagement.models.Item;
import com.codingdojo.stackmanagement.repositories.ItemRepository;

@Service
public class ItemService {

	@Autowired
	ItemRepository itemRepository;
	
	public Page<Item> getPagedItems(int page, int size, String keyword) {
        Pageable pageable = PageRequest.of(page, size);
        if (keyword != null && !keyword.isEmpty()) {
            return itemRepository.searchAvailableItems(keyword, pageable);
        }
        return itemRepository.findAll(pageable);
    }
	
	public Page<Item> getPagedItemsbyCategory(int page, int size, String category) {
        Pageable pageable = PageRequest.of(page, size);       
        return itemRepository.findByCategory(pageable, category);
    }
	
	
	public Item createItem(Item item) {
		return itemRepository.save(item);
	}
	
	public Item findItem(Long id) {
		Optional<Item> optionalItem = itemRepository.findById(id);
		if (optionalItem.isPresent()) {
			return optionalItem.get();
		} else {
			return null;
		}
	}
	
	public Item updateItem(Item it) {
		Optional<Item> optionalItem = itemRepository.findById(it.getId());
		if (optionalItem.isPresent()) {
			Item item = optionalItem.get();
			item.setName(it.getName());
			item.setCategory(it.getCategory());
			item.setStock(it.getStock());
			item.setExpiryDate(it.getExpiryDate());
			item.setPrice(it.getPrice());
			item.setPurchaseDate(it.getPurchaseDate());
			return itemRepository.save(item);
		} else {
			System.out.println("No item with this id to be updated");
			return null;
		}
	}
	
	public List<String> getAllCategories() {
		return itemRepository.findDistinctCategories();
	}
	
	
	public Map<String, Double> getBudgetPerCategory() {
	    List<Item> allItems = itemRepository.findAll();
	    return allItems.stream()
	        .collect(Collectors.groupingBy(
	            Item::getCategory,
	            Collectors.summingDouble(Item::getPrice)
	        ));
	}
	
	public void deleteItem(Long id) {
		if (itemRepository.existsById(id)) {
			itemRepository.deleteById(id);
			System.out.println("Item has been deleted");
		} else {
			System.out.println("No Item with this id to be deleted");
		}
	}
}
