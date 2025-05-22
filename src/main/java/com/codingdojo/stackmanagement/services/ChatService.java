package com.codingdojo.stackmanagement.services;

import org.springframework.stereotype.Service;

@Service
public class ChatService {

    public String getReply(String userMessage) {
        // Simulate logic temporarily
        if (userMessage.toLowerCase().contains("budget")) {
            return "Your current budget is $500.";
        } else if (userMessage.toLowerCase().contains("add item")) {
            return "What item would you like to add?";
        }
        return "Sorry, I didn't understand that.";
    }
}
