package com.codingdojo.stackmanagement.controllers;

import org.springframework.web.bind.annotation.*;

@RestController 
public class ChatController {

    @PostMapping("/chat")
    public String chat(@RequestBody MessageDTO message) {
        System.out.println("✅ Message received: " + message.getMessage());
        return "You said: " + message.getMessage(); // TEMP for testing
    }

    public static class MessageDTO {
        private String message;
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
