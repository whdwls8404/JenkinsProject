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
		fnFileCheck();
		fnAddBoard();
	});
	
	// 첨부파일점검 (확장자 + 크기)
	function fnFileCheck() {
		$('#origin').change(function() {
			
			let regFile = /(.*)\.(jpg|jpeg|png|gif)$/;	// 첨부파일점검 (확장자 + 크기)	let regFile = /파일명\.(jpg|jpeg|png|gif)$/;
			let maxSize = 1024 * 1024 * 10;	// 최대 크기 10MB
			
			let files = $('#origin')[0].fles;	
			for (let i = 0; i < files.length; i++) {
				if (regFile.test(files[i].name) == false) {
					alert('이미지만 첩부할 수 있습니다.');
					$(this).val('');
					return;
				}
				if (file[i].size > maxSize) {	// files[i].size : 첨부된 파일 크기
					alert('10MB 이하의 파일만 업로드가 가능합니다.');
					$(this).val('');
					return;
				}
			}
			
		});
		
	} 	// end fnFileCheck
	
	// 게시판 등록 함수
	function fnAddBoard() {
		$('#insert_btn').click(function() {
			if ($('#origin').val() == '') {
				alert('첨부는 필수입니다.');
				return;
			}
			// ajax의 파일업로드는 가상 form 사용 (form 객체)
			var formData = new FormData();
			formData.append('origin', $('#origin')[0].files[0]);	// 첨부를 FormData에 넣기
			$.ajax({
				url: '/jenkinsproject/api/boards',
				type: 'post',
				contentType: false,	// ajax 파일 첩부할 때 세팅
				processData: false,	// ajax 파일 첩부할 때 세팅
				data: formData,
				dataType: 'json',
				success: function() {
					
				}
			});
		});
	}	// end fuAddBoard
	
</script>
</head>
<body>

	<h1>게시판 관리</h1>
	
	<div>
		<form id="f">
			작성자 <input type="text" name="writer" id="writer"><br>
			제목 <input type="text" name="title" id="title"><br>
			내용 <input type="text" name="content" id="content"><br>
			첨부 <input type="file" name="origin" id="origin" multiple><br> <!-- 다중첨부  -->
			<input type="button" value="등록"  id="insert_btn">
		</form>
	</div>
	<div id="upload_result"></div>
	
	<hr>

</body>
</html>