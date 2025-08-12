package com.smhrd.web.dto;

import java.util.List;



import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderPayloadDTO {
    private List<Item> list;

    public static class Item {
        private Integer res_idx; // 식당 PK
        private Integer pos;     // 1부터
        public Integer getRes_idx() { return res_idx; }
        public void setRes_idx(Integer res_idx) { this.res_idx = res_idx; }
        public Integer getPos() { return pos; }
        public void setPos(Integer pos) { this.pos = pos; }
    }

    public List<Item> getList() { return list; }
    public void setList(List<Item> list) { this.list = list; }
	
}
