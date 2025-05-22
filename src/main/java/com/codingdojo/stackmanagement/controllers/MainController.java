package com.codingdojo.stackmanagement.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.data.domain.Page;

import com.codingdojo.stackmanagement.models.Item;
import com.codingdojo.stackmanagement.models.LoginUser;
import com.codingdojo.stackmanagement.models.User;
import com.codingdojo.stackmanagement.repositories.ItemHistoryRepository;
import com.codingdojo.stackmanagement.services.ItemService;
import com.codingdojo.stackmanagement.services.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import java.util.Map;

@Controller

@RequestMapping("/")

public class MainController {
	
	@Autowired
	ItemService itemService;
	
	@Autowired
    private UserService userServ;
	
	@Autowired
	ItemHistoryRepository itemHistoryRepository;

    // === Show login/register page ===
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("newUser", new User());
        model.addAttribute("newLogin", new LoginUser());
        return "index.jsp";
    }

    // === Register new user ===
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("newUser") User newUser,
                           BindingResult result,
                           Model model,
                           HttpSession session) {

        userServ.register(newUser, result);

        if (result.hasErrors()) {
            model.addAttribute("newLogin", new LoginUser());
            return "index.jsp";
        }

        session.setAttribute("userId", newUser.getId());
        return "redirect:/items";
    }

    // === Login existing user ===
    @PostMapping("/login")
    public String login(@Valid @ModelAttribute("newLogin") LoginUser newLogin,
                        BindingResult result,
                        Model model,
                        HttpSession session) {

        User user = userServ.login(newLogin, result);

        if (result.hasErrors()) {
            model.addAttribute("newUser", new User());
            return "index.jsp";
        }

        session.setAttribute("userId", user.getId());
        return "redirect:/items";
    }

    // === Logout user ===
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.setAttribute("userId", null);
        return "redirect:/";
    }
 	
    // === View All items for User  with search and category filter ===
	@GetMapping("/items")
	public String itemAll(Model model, HttpSession session, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "4") int size,
			@RequestParam(required = false) String keyword, @RequestParam(required = false) String category) {
		
		model.addAttribute("item", new Item());
		
		if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
		
		Long userId = (Long) session.getAttribute("userId");
        User user = userServ.findById(userId);
        model.addAttribute("user", user);
        
		Page<Item> items;
	    
	    if (category != null && !category.isEmpty()) {
	    	items = itemService.getPagedItemsbyCategory(page, size, category, userId);
	    } else {
	    	items = itemService.getPagedItems(page, size, keyword, userId);
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
	
	
	// === Add new item and log it in logs + added in table item history (for charts) ===
	@PostMapping("/item/new")
	public String create(@Valid @ModelAttribute("item") Item item, BindingResult result, HttpSession session, Model model, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "4") int size,
			@RequestParam(required = false) String keyword) {
		model.addAttribute("categories", itemService.getAllCategories());
		Long userId = (Long) session.getAttribute("userId");

		if (result.hasErrors()) {
	        model.addAttribute("items", itemService.getPagedItems(page, size, keyword, userId).getContent());
	        return "dashboard.jsp";
	    } else {
	    	item.setUser(userServ.findById(userId));
	        itemService.createItem(item);
	        itemService.logHistory(item, "ADDED");
	        
	        @SuppressWarnings("unchecked")
			ArrayList<String> logs = (ArrayList<String>) session.getAttribute("logs");
	        
	        if (logs == null) {
				logs = new ArrayList<>();
			}

			if (logs.size() > 4) {
				logs.remove(4);
			}

			String priceFormatted = String.format("%.2f", item.getPrice());
			logs.add(0, "Added item: " + item.getName() + " | Price: $" + priceFormatted);

			session.setAttribute("logs", logs);
			
	        return "redirect:/items";
	    }
	}

    // === Update Budget ===
	@PostMapping("/update-budget")
	public String updateBudget(@RequestParam("budget") Double newBudget, HttpSession session, RedirectAttributes redirectAttributes) {
	    Long userId = (Long) session.getAttribute("userId");
	    
	    if (userId == null) {
	        redirectAttributes.addFlashAttribute("error", "You must be logged in to update budget.");
	        return "redirect:/dashboard";
	    }

	    User user = userServ.findById(userId);
	    if (user == null) {
	        redirectAttributes.addFlashAttribute("error", "User not found.");
	        return "redirect:/dashboard";
	    }

	    user.setBudget(newBudget);
	    userServ.save(user);

	    redirectAttributes.addFlashAttribute("success", "Budget updated successfully.");
	    return "redirect:/dashboard"; // or /dash, depending on what you want
	}
    
    // === View item details ===
    @GetMapping("/items/{id}")
	public String show(@PathVariable Long id, Model model, HttpSession session) {
    	Long userId = (Long) session.getAttribute("userId");
    	if (userId == null) {
            return "redirect:/";
        }
    	
		Item item = itemService.findItem(id);
		model.addAttribute("item", item);
		return "showItem.jsp";
	}
    
    // === Edit item + added in table item history (for charts) ===
    
    @PutMapping("/item/{id}/edit")
	public String update(@Valid @ModelAttribute("item") Item item, BindingResult result, Model model) {
		
		if (result.hasErrors()) {
			model.addAttribute("item", item);
			return "showItem.jsp";
		} else {
			itemService.updateItem(item);
			itemService.logHistory(item, "EDITED");
			return "redirect:/items/"+item.getId();
		}
	}
    
    // === Dashboard for the charts  ===
    // budgetPerCategory for the budget of each category
    // userBudget for user expenses and savings ( How much they spent in total )
    
    @GetMapping("/dashboard")
	public String budgetDetails(Model model, HttpSession session) {

    	Long userId = (Long) session.getAttribute("userId");
    	if (userId == null) {
            return "redirect:/";
        }

		List<Object[]> budgetData = itemHistoryRepository.sumPriceByCategoryForUser(userId);

        Map<String, Double> budgetMap = new HashMap<>();
        for (Object[] row : budgetData) {
            budgetMap.put((String) row[0], (Double) row[1]);
        }

        model.addAttribute("budgetPerCategory", budgetMap);
        
        User user = userServ.findById(userId);
        
        double totalSpent = budgetMap.values().stream()
        	    .mapToDouble(Double::doubleValue)
        	    .sum();
        	model.addAttribute("totalSpent", totalSpent);
        	
        double userBudget = user.getBudget();
        model.addAttribute("userBudget", userBudget);
        
        
		return "budgetDetails.jsp";
	}
    
    // === Delete Item  ===
    
    @DeleteMapping("/item/{id}")
	public String delete(@PathVariable("id") Long id) {
    	itemService.logHistory(itemService.findItem(id), "DELETED");
    	itemService.deleteItem(id);
		return "redirect:/items";
	}
}
