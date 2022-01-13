<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<script type="text/javascript">
	
	// 페이지 로드
	$(document).ready(function() {
		fnInit();	// 입력 품 초기화 함수
		fnFindAllMember();	// 전체 회원 목록 함수
		fnAddMember();	// 회원 등록
		fnFindMember();	// 회원 조회 함수
		fnModifyMember();	// 회원 정보 수정 함수
		fnRemoveMember();	// 삭제 함수
		fnChangePage();	// 페이징 링크 처리 함수
	});
	
	// 입력 품 초기화 함수
	function fnInit() {
		$('#memberNo').val('');
		$('#id').val('').prop('reaonly', false);
		$('#name').val('');
		$('input:radio[name="gender"]').prop('checked', false);
		$('#address').val('');
	}
	
	// 전체 회원 목록 함수 + page 전역변수
	var page = 1;	// 전체 회원 함수 추가하면 
	function fnFindAllMember() {	// 전체 회원 목록 함수
		$.ajax({
			url: '/jenkinsproject/api/members/page/' + page,
			type: 'get',
			dataType: 'json',
			success: function(map) {
				fnPrintMemberList(map);
				fnPrintPaging(map.pageUtils);
			}
		});
	}	// end fnFindAllMember
	
	// 회원 목록 출력만 하는 함수
	function fnPrintMemberList(map) {
		// 목록 초기화
		$('#member_list').empty();
		// 페이지 처리 모든 정보 를 변수 p에 저장
		var p = map.pageUtile;
		// 목록 만들기
		if (map.pageUtils.totalRecord == 0) {	// length.
			$('<tr>')
			.append ( $('<td colspan="5">').text('등록된 회원이 없습니다.') )
			.appendTo( '#member_list');
		} else {
			$.each(map.list, function(i, member) {
				$('<tr>')
				.append( $('<td>').text(member.id) )
				.append( $('<td>').text(member.name) )
				.append( $('<td>').text(member.gender) )
				.append( $('<td>').text(member.address) )
				.append( $('<td>').html( $('<input type="hidden" name="memberNo" value="' + member.memberNo + '"><input type="button" value="조회" class="view_btu">')))
				.appendTo('#member_list');
			});
			// $('#paging').html(map.paging);	// 다음 페이지 넘어가는 숫자와 ◀ 나타난다.
		}
	}	// end fnPrintMemberList
	
	// 페이징 출력 함수
	function fnPrintPaging(p) {
		// 페이징 영역 초기화
		$('#paging').empty();
		// 1페이지로 이동
		if (page == 1) {
			// $('<div class="disable_link">&lt;&lt;</div>').appendTo('#paging');
			$('<div>').addClass('disable_link').html('&lt;&lt;').appendTo('#paging');
		} else {
			// $('<div class="enable_link" data-page="1">&lt;&lt;</div>').appendTo('#paging');
			$('<div>').addClass('enable_link').html('&lt;&lt;').attr('data-page', 1).appendTo('#paging');
		}
		// 이전 블록으로 이동
		if (page <= p.pagePerBlock) {
			$('<div class="disable_link">&lt;</div>').appendTo('#paging');
		} else {
			$('<div class="enable_link" data-page="'+(p.beginPage-1)+'">&lt;</div>').appendTo('#paging');
		}
		// 페이지 번호
		for (let i = p.beginPage; i <= p.endPage; i++) {
			if (i == page) {
				$('<div class="disable_link now_page">'+i+'</div>').appendTo('#paging');
			} else {
				$('<div class="enable_link" data-page="'+i+'">'+i+'</div>').appendTo('#paging');
			}
		}
		// 다음 블록으로 이동
		if (p.endPage == p.totalPage) {
			$('<div class="disable_link">&gt;</div>').appendTo('#paging');
		} else {
			$('<div class="enable_link" data-page="'+(p.endPage+1)+'">&gt;</div>').appendTo('#paging');
		}
		// 마지막 페이지로 이동
		if (page == p.totalPage) {
			$('<div class="disable_link">&gt;&gt;</div>').appendTo('#paging');
		} else {
			$('<div class="enable_link" data-page="'+p.totalPage+'">&gt;&gt;</div>').appendTo('#paging');
		}
	}  // end fnPrintPaging
	
	// 페이징 링크 처리 함수(전역변수 page값을 바꾸고, fnFindAllMember() 호출)
	function fnChangePage(){
		$('body').on('click', '.enable_link', function(){
			page = $(this).data('page');
			fnFindAllMember();
		});
	}  // end fnChangePage
	
	// 회원 등록
	function fnAddMember() {
		$('#insert_btn').click(function() {
			let member = JSON.stringify({
				id: $('#id').val(),	// 아이디
				name: $('#name').val(),	// 이름
				gender: $('input:radio[name="gender"]:checked').val(),	// 주소
				address: $('#address').val()
			});
			$.ajax({
				url: '/jenkinsproject/api/members',
				type: 'post',
				contentType: 'application/json',
				data: member,
				dataType: 'json',
				success: function(map) {
					alert('회원번호 ' + map.mamberNo + '인 회원이 등록되었습니다.');
					fnFindAllMember();
					fnInit();
				},
				error: function(xhr) {
					if (xhr.status == 500) {
						alert(xhr.responseText);
					} else if (xhr.status == 501) {
						alert(xhr.responseText);
					}
				}
			});
		});
	} // end fnAddMeber
	
	// 회원 조회 함수	클릭면  아이디 이름 주소 성별이 검색창에 나타난다.
	function fnFindMember() {
		$('body').on('click', '.view_btu', function() {
			// $('#id').attr('readonly', true);
			$.ajax({
				url: '/jenkinsproject/api/members/' + $(this).prev().val(),
				type: 'get',
				dataType: 'json',
				success : function(map) {
					if (map.member != null) {
						$('#memberNo').val(map.member.memberNo);
						$('#id').val(map.member.id).prop('readonly', true);
						$('#name').val(map.member.name);
						$('#address').val(map.member.address);
						$('input:radio[name="gender"][value="'+map.member.gender+'"]').prop('checked', true);
					} else {
						alert($(this).prev().val() + '번 회원 정보가 없습니다.')
					}
				}
					
			});
		});
	}	// end fnFindMember
	
	// 회원 정보 수정 함수
	function fnModifyMember() {
		$('#update_btn').click(function() {
			let member = JSON.stringify({
				memberNo: $('#memberNo').val(), // 번호
				name: $('#name').val(),	// 이름
				gender: $('input:radio[name="gender"]:checked').val(),	// 조수
				address: $('#address').val()
			});
			$.ajax({
				url: '/jenkinsproject/api/members',
				type: 'put',
				contentType: 'application/json',
				data: member,
				dataType: 'json',
				success: function(map) {
					if (map.result > 0) {
						alert('회원 정보가 수정되었습니다.');
						fnFindAllMember();
					} else {
						alert('회원 정보가 수정되지 않았습니다.');
					}
				}
			});
		});
	} // end fnModifyMember
	
	// 삭제 함수
	function fnRemoveMember(){
		$('#delete_btn').click(function(){
			if (confirm('삭제할까요?')){
				$.ajax({
					url: '/jenkinsproject/api/members/' + $('#memberNo').val(),
					type: 'delete',
					dataType: 'json',
					success: function(map){
						if (map.result > 0) {
							alert('회원이 삭제되었습니다.');
							fnFindAllMember();
							fnInit();
						} else {
							alert('회원이 삭제되지 않았습니다.');
						}
					}
				});
			}
		});
	}  // end fnRemoveMember
	
</script>
<style>
	#paging {
		display: flex;
		justify-content: center;
	}
	#paging > div {
		width: 20px;
		height: 20px;
		text-align: center;
	}
	.disable_link {
		color: lightgray;
	}
	.enable_link {
		cursor: pointer;
	}
	.now_page {
		color: red;
	}
</style>
</head>
<body><!-- 회원이 -->

	<h1>회원 관리</h1>
	
	<div>
		<input type="hidden" name="memberNo" id="memberNo"><!-- 번호 -->
		아이디 <input type="text" name="id" id="id"><br>
		이름   <input type="text" name="name" id="name"><br>
		주소   <input type="text" name="address" id="address"><br>
		성별   
		<input type="radio" name="gender" value="남" id="male"><label for=male>남</label>
		<input type="radio" name="gender" value="여" id="femmale"><label for=femmale>여</label><br>
		<input type="button" value="초기화" onclick="fnInit()">
		<input type="button" value="등록" id="insert_btn">
		<input type="button" value="수성" id="update_btn">
		<input type="button" value="삭제" id="delete_btn">
	</div>
	
	<table border="1">
		<thead>
			<tr>
				<td>아이디</td>
				<td>이름</td>
				<td>주소</td>
				<td>성별</td>
				<td></td>
			</tr>
		</thead>
		<tbody id="member_list">
		
		</tbody>
		<tfoot>
			<tr>
				<td colspan="5" id="paging"><div id="paging"></div></td>
			</tr>
		</tfoot>
	</table>

</body>
</html>