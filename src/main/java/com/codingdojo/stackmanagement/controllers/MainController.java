package com.codingdojo.stockmanagement.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import com.codingdojo.stockmanagement.LoginUser;
import com.codingdojo.stockmanagement.User;
import com.codingdojo.stockmanagement.UserService;
import com.codingdojo.stockmanagement.UserService;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.codingdojo.stackmanagement.models.Item;
import com.codingdojo.stackmanagement.services.ItemService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller

@RequestMapping("/")

public class MainController {
	
	@Autowired
	ItemService itemService;
	
	@GetMapping("/dashboard")
	public String choresAll(Model model, HttpSession session, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "4") int size,
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

    @Autowired
    private UserService userServ;

   // @Autowired
   // private UserService Service;

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
        return "redirect:/dashboard";
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
        return "redirect:/dashboard";
    }

    // === Logout user ===
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.setAttribute("userId", null);
        return "redirect:/";
    }

    // === Dashboard page ===
    @GetMapping("/dashboard")
    public String home(Model model, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }

        Long userId = (Long) session.getAttribute("userId");
        User user = userServ.findById(userId);
        model.addAttribute("user", user);
        return "dashboard.jsp";
    }

    // === Update Budget ===
    @PostMapping("/update-budget")
    public String updateBudget(@RequestParam("budget") Double newBudget, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/";
        }

        User user = userServ.findById(userId);
        if (user != null) {
            user.setBudget(newBudget);
            userServ.save(user);
        }

        return "redirect:/dashboard";
    }
}
