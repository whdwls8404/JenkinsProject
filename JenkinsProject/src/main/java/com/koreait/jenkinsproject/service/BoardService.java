package com.koreait.jenkinsproject.service;

import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.koreait.jenkinsproject.domain.Board;

public interface BoardService {
	public Map<String, Object> addBoard(MultipartHttpServletRequest multipartRequest);
}
