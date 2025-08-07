package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.smhrd.web.entity.t_notification;

@Mapper
public interface NotificationMapper {

    @Insert("""
        INSERT INTO t_notification (sender_id, receiver_id, type, target_id, content)
        VALUES (#{sender_id}, #{receiver_id}, #{type}, #{target_id}, #{content})
    """)
    void insertNotification(t_notification noti);

    @Select("""
        SELECT * FROM t_notification
        WHERE receiver_id = #{receiver_id}
        ORDER BY created_at DESC
        Limit 50
    """)
    List<t_notification> getNotificationsByReceiver(@Param("receiver_id") String receiverId);

    @Update("""
        UPDATE t_notification
        SET is_read = TRUE
        WHERE noti_id = #{noti_id}
    """)
    void markAsRead(@Param("noti_id") int notiId);
}
