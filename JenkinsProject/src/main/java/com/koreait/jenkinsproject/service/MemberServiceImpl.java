package com.koreait.jenkinsproject.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.koreait.jenkinsproject.domain.Member;
import com.koreait.jenkinsproject.repository.MemberRepository;
import com.koreait.jenkinsproject.util.PageUtils;

public class MemberServiceImpl implements MemberService {

private MemberRepository repository;
	
	public MemberServiceImpl(SqlSessionTemplate sqlSession) {
		repository = sqlSession.getMapper(MemberRepository.class);
	}
	
	
	@Override	// 회원 목록	//	뺴면 (Integer page) 상관이 없다.
	public Map<String, Object> findAllMember(Integer page) {
		
		int totalRecord = repository.selectMemberCount();	// 뺴도 상관없다.
		PageUtils pageUtils = new PageUtils();	// 뺴도 상관없다.
		pageUtils.setPageEntity(totalRecord, page);	// 뺴도 상관없다.
		
		Map<String, Object> m = new HashMap<String, Object>();	// 뺴도 상관없다.
		m.put("beginRecord", pageUtils.getBeginRecord());	// 뺴도 상관없다.
		m.put("endRecord", pageUtils.getEndRecord());	// 뺴도 상관없다.
		List<Member> list = repository.selectMemberList(m);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageUtils", pageUtils); // 뺴도 상관없다.
		map.put("list", list);	//list.size() = totalRecord 변경돼것임
		// if (totalRecord == 0) {	map.put("list", null);	} else { map.put("list", list);	}// map.put("paging", pageUtils.getPageEntity("api/members/page/"));	// 뺴도 상관없다.
		return map;
	}

	@Override	// 회원 조회
	public Map<String, Object> findMember(Long memberNo) {
		Member member = repository.selectMemberByNo(memberNo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("member", member);
		return map;
	}

	@Override	// 회원 등록
	public Map<String, Object> addMember(Member member) {	// 받아온 member에는 memberNo 없은
		int result = repository.insertMember(member);	// DB로 member를 보내면 selectKey 태그로 member에 memberNo가 저장됨
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);	// 성공 유무 판단용 0 또는 1
		map.put("memberNo", member.getMemberNo());	// DA를 다녀온 뒤에는 member에 memberNo가 있음 
		return map;
	}

	@Override	// 회원 정보 수정
	public Map<String, Object> modifyMember(Member member) {
		int result = repository.updateMember(member);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		return map;  // repository.updateMember(member);
	}

	@Override	// 회원 삭제
	public Map<String, Object> removeMember(Long memberNo) {
		int result = repository.deleteMember(memberNo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		return map;  //repository.deleteMember(memberNo);
	}

}
