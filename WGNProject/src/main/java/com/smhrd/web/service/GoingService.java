package com.smhrd.web.service;




import java.util.List;

import com.smhrd.web.entity.t_going;


public interface GoingService {
	

	boolean insertGoing(int res_idx, String mb_id);

    boolean deleteGoing(int res_idx, String mb_id);
    
    boolean isGoing(int res_idx, String mb_id);

	List<t_going> getmygoing(String mb_id);

}

