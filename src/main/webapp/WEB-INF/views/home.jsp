<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>

	<!-- ajax 라이센스 파일 -->
	<script type="text/javascript" src="./resources/AUIGrid/AUIGrid.js"></script>
	<script type="text/javascript" src="./resources/AUIGrid/AUIGridLicense.js"></script>
	
	<!-- ajax 요청을 위한 스크립트 -->
	<script type="text/javascript" src="./resources/samples/ajax.js"></script>
	<script type="text/javascript" src="./resources/samples/common.js"></script>
	
	<!-- AUIGrid PDF 다운로드를 위한 라이브러리 -->
	<script type="text/javascript" src="./resources/pdfkit/AUIGrid.pdfkit.js"></script>
	
	<!-- 브라우저 다운로딩 할 수 있는 JS 추가 -->
	<script type="text/javascript" src="./resources/export_server_samples/FileSaver.min.js"></script>
	
	<!-- 그리드 css 파일 -->
	<link rel="stylesheet" href="./resources/AUIGrid/AUIGrid_style.css">

	<style type="text/css">
	/* 커스텀 컬럼 스타일 정의 */
	.aui-grid-user-custom-left {
		text-align: left;
	}
	
	.aui-grid-user-custom-right {
		text-align: right;
	}
	
	/* 그리드 오버 시 행 선택자 만들기 */
	.aui-grid-body-panel table tr:hover {
	background:#D9E5FF;
	color:#000;
	}
	.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
		background:#D9E5FF;
		color:#000;
	}
	
	/* 수정 팝업창 설정 */
	
	
	</style>
	
	<script type="text/javascript">
	
	</script>

	<title>Home</title>
</head>
<body>
	<div><a href="/grid">Home</a></div>

	<h3>그리드 생성</h3>
	
	<div id="grid_wrap" style="width: 900px; height: 480px;"></div>
	
	<br>
	
	<div>
		<button id="excelDownload" onclick="exportToLocal()">Excel Download</button>
		<button id="pdfDownload" onclick="exportPdfClick()">PDF Download</button>
	</div>
	
	<br>
	
	<div>
		<button id="cellMergeRowSpan" onclick="cellMergeRowSpan()">셀 세로 병합</button>
		<button id="cellMergeColumnSpan" onclick="cellMergeColumnSpan()">셀 가로 병합</button>
		<button id="crudTest">CRUD 테스트</button>
		<button id="createGrid">그리드 생성</button>
	</div>
	
	<br>
	
	<div>
		<button onclick="jsExam()">JS 예제</button>
		<button id="sc">선사 관리</button>
	</div>
	
	
	<script type="text/javascript">
	
	// AUIGrid 메소드 확인
	// console.log(AUIGrid);
	
	// 그리드 생성 후 해당 ID 보관 변수
	var myGridID;
	
	/* 컬럼 레이아웃 작성 */
	var columnLayout = [
		{
	        dataField : "id",		// 데이터를 매핑해줄 때 사용할 이름. 예를 들어 {"id" : "test"} 라는 데이터를 받으면 test라는 데이터는 이 컬럼 안에 위치하게 됩니다.
	        headerText : "아이디",	// 사용자에게 보여줄 이름(헤더)
	        width : 120,			// 컬럼의 너비
	        editable : false,
	        renderer : { 			// HTML 템플릿 렌더러 사용 : <a> 태그같이 문자 그대로가 아닌 html 코드로 인식 시켜야 할 때 필요한 설정
				type : "TemplateRenderer"
			},
	        /* labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
				// 순서대로 줄, 컬럼, (받은)값, 헤더문구.. 순서입니다.
	            if(!value) return "";
				var template = '<div class="my_div">';
				template += '<a href="/board/boardView.do?seq=' + value + '">' + value + '</a>';
				template += '</div>';
				return template; // HTML 템플릿 반환. 그대로 innerHTML 속성값으로 처리됨
	        }, */
	        dataType : "String"
		}, {
	        dataField : "name",
	        headerText : "이름",
	        width: 100,
	        style: "aui-grid-user-custom-left",
	        renderer : {
				type : "IconRenderer",
				iconWidth : 20, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
				iconHeight : 20,
				iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
					"default" : "./resources/samples/assets/office_man.png" // default
				}
			},
		}, {
	        dataField : "country",
	        headerText : "나라",
	        /* renderer : {
	        	type : "IconRenderer",
				iconWidth : 20, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
				iconHeight : 20,
				iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
					"Korea" : "./resources/samples/assets/korea.png" // korea
				}
	        } */
		}, {
	        dataField : "flag",
	        headerText : "Flag IMG",
	        editable : false,
	        prefix : "./resources/samples/assets/",
	        renderer : {
	        	type : "ImageRenderer",
				imgHeight : 20,
				altField : "country"
	        },
	        width: 80,
		}, {
	        dataField : "product",
	        headerText : "제품",
	        style: "aui-grid-user-custom-left",
	        dataType : "String",
	        width: 100
		}, {
	        dataField : "color",
	        headerText : "Color",
	        style: "aui-grid-user-custom-left",
	        renderer : {
	        	type: "IconRenderer",
	        	iconWidth: 20,	// icon 가로 사이즈, 지정하지 않으면 기본값 24
	        	iconHeight: 20,
	        	iconTableRef: { // icon 값 참조할 테이블 레퍼런스
	        		"Blue": "./resources/samples/assets/blue_circle.png",
	        		"Gray" : "./resources/samples/assets/gray_circle.png",
					"Green" : "./resources/samples/assets/green_circle.png",
					"Orange" : "./resources/samples/assets/orange2_circle.png",
					"Pink" : "./resources/samples/assets/pink_circle.png",
					"Violet" : "./resources/samples/assets/violet_circle.png",
					"Yellow" : "./resources/samples/assets/yellow_circle.png",
					"Red" : "./resources/samples/assets/orange_circle.png",
					"default" : "./resources/samples/assets/glider.png" //default
	        	}
	        },
		}, {
	        dataField : "price",
	        headerText : "가격",
	        dataType : "numeric",
	        style: "aui-grid-user-custom-right",
	        editRenderer : {
				type : "InputEditRenderer",
				onlyNumeric : true, // 0~9만 입력가능
				textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
				autoThousandSeparator : true // 천단위 구분자 삽입 여부
			},
			width: 70
		}, {
	        dataField : "quantity",
	        headerText : "수량",
	        width: 50
		}, {
	        dataField : "date",
	        headerText : "날짜",
	        dataType : "date",
			dateInputFormat : "yyyy-mm-dd", // 데이터의 날짜 형식
			formatString : "yyyy-mm-dd", // 그리드에 보여줄 날짜 형식
	        width : 120
		}
		
	];
	//설정을 통해 컬럼의 포멧을 변환하는 등, 자세한 설정이 가능합니다. 해당 설정은 홈페이지를 참고합니다.
	
	// 윈도우 onload 이벤트 핸들링 : 페이지가 로드될 때 ajax 요청을 통해 데이터 로드
	// 만약 jQuery 사용 시, $(document).ready(function() {}); or $(function() {}); 사용
	window.onload = function() {
		
		// 그리드 속성 설정
		var auiGridProps = {
				// 편집 가능 여부 (기본값:false)
				editable : true,
				
				// 셀 병합 실행
				enableCellMerge : false,
				
				// 엔터키가 다음 행이 아닌 다음 컬럼으로 이동할지 여부 (기본값:false)
				enterKeyColumnBase : true,
				
				// 셀 선택모드 (기본값:singCell) > 다중 선택
				selectionMode : "miltipleCells",
				
				// 컨텍스트 메뉴 사용 여부 (기본값:false)
				useContextMenu : true,
				
				// 필터 사용 여부 (기본값:false)
				enableFilter : false,
				
				// 그룹핑 패널 사용
				showstateColumn : true,
				
				// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값:false)
				displayTreeOpen : false,
				
				noDataMessage : "출력할 데이터가 없습니다.",
				
				groupingMessage : "여기에 컬럼을 드래그하면 그룹핑이 됩니다.",
				
				/* rowIDFiled : "id", */
				
		};
		
		// 실제로 #grid_wrap에 그리드 생성
		myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
		
		// Ajax 요청 실행
        requestAjax();
		
	};

	// Ajax 요청을 합니다.
	function requestAjax() {
	 
		// ajax 요청 전 그리드에 로더 표시(로딩 중 표시)
		AUIGrid.showAjaxLoader(myGridID);

		// ajax(XMLHttpRequest)로 그리드 데이터 요청
		ajax({
		     url: "./resources/samples/data/normal_100.json",	// 샘플 데이터 url
		     onSuccess: function(data) {
                if(!data) {
                	console.log("asdfasdfasdfasdf");
                	return;
                };
                
                console.log("데이터 조회");
                
                // 그리드 데이터
                var gridData = data;
                
                // 로더 제거
                AUIGrid.removeAjaxLoader(myGridID);
                         
                // 그리드에 데이터 세팅
                AUIGrid.setGridData(myGridID, gridData);
		               
		     },
		     onError: function(status, e) {
                alert("데이터 요청에 실패하였습니다.\r status : " + status);
		     }
		});
	};
	
	
	
	
	
	
	/* 셀 병합 */
	function cellMergeRowSpan() {
		console.log("셀 세로 병합");
		
		location.href = "./cellMerge/rowSpan";
	}
	
	function cellMergeColumnSpan() {
		console.log("셀 가로 병합");
		
		location.href = "./cellMerge/columnSpan";
	}
	
	/* crud 테스트 */
	var crudTest = document.getElementById("crudTest");
	
	crudTest.addEventListener("click", function(e) {
		
		location.href = "./crud/crud";
	});
	
	/* 그리드 생성 */
	var crudTest = document.getElementById("createGrid");
	
	crudTest.addEventListener("click", function(e) {
		
		location.href  = "./crud/createGrid";
	});
	
	
	/* js 예제 */
	function jsExam() {
		location.href = "./jsExam/jsExam";
	}
	
	
	/* 선사 관리 */
	var sc = document.getElementById("sc");
	
	sc.addEventListener("click", function() {
		
		location.href = "./exam/shippingCompanyMng";
	});
	
	
	
	
	
	/* PDF 내보내기 */
	// var pdfDown = document.getElementById("excelDownload");

	// PDF Download 버튼 클릭 시 exportPdfClick 함수 실행
	// pdfDown.onclick = exportPdfClick;
	
	function exportPdfClick() {
		console.log("PDF 다운로드");
		
		// 완전한 HTML5 를 지원하는 브라우저에서만 PDF 저장 가능( IE=10부터 가능 )
		if(!AUIGrid.isAvailabePdf(myGridID)) {
			alert("PDF 저장은 HTML5를 지원하는 최신 브라우저에서 가능합니다.");
			return;
		}
		// 그리드가 작성한 엑셀, CSV 등의 데이터를 다운로드 처리할 서버 URL을 지시합니다.
		// 서버 사이드 스크립트가 JSP 이라면 ./export/export.jsp 로 변환해 주십시오.
		// 스프링 또는 MVC 프레임워크로 프로젝트가 구축된 경우 해당 폴더의 export.jsp 파일을 참고하여 작성하십시오.
		AUIGrid.setProperty(myGridID, "exportURL", "/auiPDF");
		// 내보내기 실행
		AUIGrid.exportToPdf(myGridID, {
		// 폰트 경로 지정 (필수)
			fontPath : "./resources/pdfkit/jejugothic-regular.ttf"
		});
	};
	
	
	// APACHE의 POI 라이브러리를 이용해서 다운로드 할 경우 추가합니다. 제 블로그를 참고하시면 방법이 나옵니다.
	function exportToExcelFromServer() {
		var form = document.createElement("form");
		form.setAttribute("charset", "UTF-8");
		form.setAttribute("method", "Post");  //Post 방식
		form.setAttribute("action", "요청을 보낼 주소"); //요청 보낼 주소
		
		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "page");
		hiddenField.setAttribute("value", "다운로드할 때 데이터 선정을 위해 필요한 데이터를 같이 보낼 수 있습니다.");
		form.appendChild(hiddenField);
		
		/* 
		search KeyWord 등의 검색 조건을 필요로 하는 경우 추가한다.
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "mEmail");
		hiddenField.setAttribute("value", mEmail);
		form.appendChild(hiddenField); 
		*/
		
		document.body.appendChild(form);
		form.submit();
	}
	
	
	/* 구현하기 */
	function exportToLocal() {
		console.log("Excel 다운로드");
		
		// 로컬 다운로드 가능 여부
		if(AUIGrid.isAvailableLocalDownload(myGridID)) {
			// 로컬에서 바로 내보내기 실행
			AUIGrid.exportToXlsx(myGridID);
		} else {
			// HTML5를 완전히 지원하지 않는 브라우저는 서버로 전송하여, 다운로드 처리
			//exportToServer();
			exportToServer();
		}
	};
	
	function exportToServer() {
		// 그리드가 작성한 엑셀, CSV 등의 데이터를 다운로드 처리할 서버 URL을 지시합니다.
		// 정품 및 평가판 압축 해제 후, export_server_samples 폴더 안에 PHP, JSP, ASP, ASP.NET 용 소스가 존재함
		AUIGrid.setProp(myGridID, "exportURL", "/auiEXCEL");
 
		// 내보내기 실행
		AUIGrid.exportToXlsx(myGridID, {
			// 지정된 exportURL (./server_script/export.php) 로 내보내기 합니다.
			// postToServer 를 true 설정하지 않은 경우, 기본적으로 로컬 다운로딩 처리됩니다.
			"postToServer" : true
		});
	}; 
</script>

	
</body>
</html>
