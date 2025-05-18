package com.codingdojo.stockmanagement.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import com.choreTracker.models.LoginUser;
import com.choreTracker.models.User;
import com.choreTracker.services.JobService;
import com.choreTracker.services.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/")
public class MainController {

    @Autowired
    private UserService userServ;

    @Autowired
    private JobService jobService;

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
