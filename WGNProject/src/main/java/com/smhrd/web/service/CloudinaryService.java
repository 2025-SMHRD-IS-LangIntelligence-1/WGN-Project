package com.smhrd.web.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class CloudinaryService {

    private final Cloudinary cloudinary;

    // 생성자 주입
    public CloudinaryService(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }

    // 클라우디너리에 파일을 업로드하는 메서드
    public List<String> uploadFiles(List<MultipartFile> files) throws IOException {
        List<String> urls = new ArrayList<>();
        
        for (MultipartFile file : files) {
        	if (!file.isEmpty()) {
        		Map uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
        		String url = uploadResult.get("secure_url").toString();
        		urls.add(url);
        	}
        }
        
        return urls;
    }
    
    // 클라우디너리 url에서 PublicId를 추출하는 메서드
    public String extractPublicId(String url) {
        // 예: https://res.cloudinary.com/duyrajdqg/image/upload/v1754264657/xbcfr4gpoejaidhdhmuv.png
        // 마지막 부분에서 .png 제거 후 public_id 추출
        int lastSlash = url.lastIndexOf('/'); // 가장 마지막에 나오는 '/' 의 인덱스 위치를 찾아줌
        int dotIndex = url.lastIndexOf('.'); // 가장 마지막에 나오는 '.' 의 인덱스 위치를 찾아줌
        if (lastSlash != -1 && dotIndex != -1 && dotIndex > lastSlash) { // 각각의 인덱스가 존재하는지, dotIndex가 lastSlash보다 뒤에 오는지 확인
            return url.substring(lastSlash + 1, dotIndex); // 시작 인덱스, 끝 인덱스(포함 안함)으로 String을 잘라냄
        }
        return null;
    }
    
}
