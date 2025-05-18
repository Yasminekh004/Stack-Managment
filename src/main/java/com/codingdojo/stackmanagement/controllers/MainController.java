package com.codingdojo.stackmanagement.controllers;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.codingdojo.stackmanagement.models.Item;
import com.codingdojo.stackmanagement.services.ItemService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class MainController {
	
	@Autowired
	ItemService itemService;
	
	@GetMapping("/")
	public String itemAll(Model model, HttpSession session, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "4") int size,
			@RequestParam(required = false) String keyword, @RequestParam(required = false) String category) {
		
		model.addAttribute("item", new Item());
		
		Page<Item> items;
	    
	    if (category != null && !category.isEmpty()) {
	    	items = itemService.getPagedItemsbyCategory(page, size, category);
	    } else {
	    	items = itemService.getPagedItems(page, size, keyword); // fallback to all items
	    }
	    
	    model.addAttribute("items", items.getContent());
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", items.getTotalPages());
		model.addAttribute("keyword", keyword);
		model.addAttribute("selectedCategory", category);
		
		
		List<String> categories = itemService.getAllCategories(); 
	    model.addAttribute("categories", categories);
	    
		return "dashboard.jsp";
	}

	@PostMapping("/item/new")
	public String create(@Valid @ModelAttribute("item") Item item, BindingResult result, Model model, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "4") int size,
			@RequestParam(required = false) String keyword) {
		model.addAttribute("categories", itemService.getAllCategories());
	    if (result.hasErrors()) {
	        model.addAttribute("items", itemService.getPagedItems(page, size, keyword));
	        return "dashboard.jsp"; // Stay on same page to show errors
	    } else {
	        itemService.createItem(item);
	        return "redirect:/dashboard"; // refresh page, form hidden
	    }
	}
	
	
	@GetMapping("/items/{id}")
	public String show(@PathVariable Long id, Model model, HttpSession session) {

		Item item = itemService.findItem(id);
		model.addAttribute("item", item);
		return "showItem.jsp";
	}
	
	
	
	@PutMapping("/item/{id}/edit")
	public String update(Principal principal, @Valid @ModelAttribute("item") Item item, BindingResult result,
			Model model) {
		
		if (result.hasErrors()) {
			model.addAttribute("item", item);
			return "showItem.jsp";
		} else {
			itemService.updateItem(item);
			return "redirect:/items/"+item.getId();
		}
	}
	
	@GetMapping("/dashboard")
	public String budgetDetails(Model model, HttpSession session) {

		Map<String, Double> budgetPerCategory = itemService.getBudgetPerCategory();
		model.addAttribute("budgetPerCategory", budgetPerCategory);
		return "budgetDetails.jsp";
	}
	

}
