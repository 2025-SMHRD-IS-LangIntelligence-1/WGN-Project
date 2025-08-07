package com.smhrd.web.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



import com.smhrd.web.entity.t_going;

import com.smhrd.web.mapper.GoingMapper;

@Service
public class GoingServicempl implements GoingService{
	
    @Autowired
    private GoingMapper mapper;

    @Override
    public boolean insertGoing(int res_idx, String mb_id) {
        return mapper.insertGoing(res_idx, mb_id) > 0;
    }

    @Override
    public boolean deleteGoing(int res_idx, String mb_id) {
        return mapper.deleteGoing(res_idx, mb_id) > 0;
    }

    @Override
    public boolean isGoing(int res_idx, String mb_id) {
        return mapper.isGoing(res_idx, mb_id) > 0;
    }

    @Override
    public List<t_going> getmygoing(String mb_id) {
    	List<t_going> mygoing = mapper.selectgoing(mb_id);
    	 
    	 return mygoing;
    }
    
}
