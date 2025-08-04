package com.smhrd.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/restaurant")
@Controller
public class RestaurantController {

    @GetMapping()
    public String restaurantPage() {
    	
        return "restaurant/restaurant";
    }
}