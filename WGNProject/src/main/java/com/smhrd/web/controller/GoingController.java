package com.smhrd.web.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.smhrd.web.service.GoingService;
import com.smhrd.web.service.MemberService;

@RestController
@RequestMapping("/going")
public class GoingController {

    @Autowired
    private GoingService goingService;
    @Autowired
    private MemberService memberService;

    @PostMapping("/insert")
    public Map<String, Object> insert(@RequestParam("res_idx") int res_idx,
                                      @RequestParam("mb_id") String mb_id) {
        
    	boolean result = false;
    	
    	if (mb_id != null) {
    		result = goingService.insertGoing(res_idx, mb_id);
    		memberService.saveLog(mb_id, res_idx, "찜");
    	}
        
        return Map.of("success", result);
    }

    @DeleteMapping("/delete")
    public Map<String, Object> delete(@RequestParam("res_idx") int res_idx,
                                      @RequestParam("mb_id") String mb_id) {
        boolean result = goingService.deleteGoing(res_idx, mb_id);
        return Map.of("success", result);
    }

    @PostMapping("/check")
    public Map<String, Object> check(@RequestParam("res_idx") int res_idx,
                                     @RequestParam("mb_id") String mb_id) {
        boolean result = goingService.isGoing(res_idx, mb_id);
        return Map.of("isGoing", result);
    }

    
}
