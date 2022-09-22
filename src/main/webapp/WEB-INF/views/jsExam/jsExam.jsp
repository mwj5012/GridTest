<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div><a href="/grid">Home</a></div>

	<h3>JS Exam</h3>
	
	
	
	
	
	<script type="text/javascript">
	/* json 예제 */
	var param = 11;
	
	function init() {
		$.ajax({
			type: "get",
			url: "./jsExam",
			data : {
				value1 : "테스트값",
				value2 : "param"
			},
			contentType: "application/json",
			dataType : "json",
			success: function(data, status) {
				console.log(data);
				alert(status);
			},
			error: function(status) {
				alert(status + "error!");
			}
		})
	}
	
	
	
	</script>
</body>
</html>