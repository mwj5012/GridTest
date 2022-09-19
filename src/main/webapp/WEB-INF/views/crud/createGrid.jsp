<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- ajax 라이센스 파일 -->
<script type="text/javascript" src="./../resources/AUIGrid/AUIGrid.js"></script>
<script type="text/javascript" src="./../resources/AUIGrid/AUIGridLicense.js"></script>

<!-- ajax 요청을 위한 스크립트 -->
<script type="text/javascript" src="./../resources/samples/ajax.js"></script>
<script type="text/javascript" src="./../resources/samples/common.js"></script>

<!-- AUIGrid PDF 다운로드를 위한 라이브러리 -->
<script type="text/javascript" src="./../resources/pdfkit/AUIGrid.pdfkit.js"></script>

<!-- 브라우저 다운로딩 할 수 있는 JS 추가 -->
<script type="text/javascript" src="./../resources/export_server_samples/FileSaver.min.js"></script>

<!-- 그리드 css 파일 -->
<link rel="stylesheet" href="./../resources/AUIGrid/AUIGrid_style.css">

<!-- jquery 추가 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<style type="text/css">
#div_1 {
	display: inline-block;
}

#p1 {
	font-size: 0.7em;
}

#div_2 {
	display: inline-block;
	margin-left: 60%;
}


</style>


<script type="text/javascript">

// AUIGrid 생성 후 반환 ID
var myGridID;

// document ready (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(function() {
	
	// AUIGrid 그리드를 생성합니다.
	createAUIGrid(columnLayout);
	
	// 데이터 요청, 요청 성공 시 AUIGrid 에 데이터 삽입합니다.
	requestData("./../resources/samples/data/test_data.json");
	
});

// AUIGrid 칼럼 설정
// 데이터 형태는 다음과 같은 형태임,
//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
var columnLayout = [ {
		dataField : "code",
		headerText : "터미널 코드",
		width : 80
	}, {
		dataField : "name",
		headerText : "터미널 명",
		width : 150
	}, {
		dataField : "abbreviation",
		headerText : "터미널 약칭",
		width : 80
	}, {
		dataField : "address",
		headerText : "터미널 주소",
		width : 140
	}, {
		headerText: "하역사",
		children: [{
			dataField : "unloader_name",
			headerText : "하역사명",
			width : 100
		}, {
			dataField : "phone",
			headerText : "전화번호",
			width : 100
		}, {
			dataField : "unloader_date",
			headerText : "시작 날짜",
			dataType : "date",
			dateInputFormat : "yyyy-mm-dd", // 데이터의 날짜 형식
			formatString : "yyyy년 mm월 dd일", // 그리드에 보여줄 날짜 형식
			width : 120
		}] // end of 하역사 children
	}, {
		dataField : "fee",	// 임의의 고유값
		headerText : "이용료",
		width : 100,
		renderer : {
			type : "ButtonRenderer",
			labelText : "상세 보기",
			onClick : function(event) {
				alert("( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.item.name + " 상세보기 클릭");
			}
		}
	}];

// AUIGrid 를 생성합니다.
function createAUIGrid(columnLayout) {
	
	// 그리드 속성 설정
	var gridPros = {

			rowIdField : "code",
			
			// 편집 가능 여부 (기본값 : false)
			editable : true,
			
			// 셀 병합 실행
			enableCellMerge : true,
			
			// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
			enterKeyColumnBase : true,
			
			// 셀 선택모드 (기본값: singleCell)
			// selectionMode : "multipleCells",
			
			// 컨텍스트 메뉴 사용 여부 (기본값 : false)
			useContextMenu : true,
			
			// 필터 사용 여부 (기본값 : false)
			enableFilter : true,
		
			// 그룹핑 패널 사용
			// useGroupingPanel : true,
			
			// 상태 칼럼 사용(No. 옆 셀 선택 화살표)
			// showStateColumn : true,
			
			// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
			displayTreeOpen : true,
			
			noDataMessage : "출력할 데이터가 없습니다.",
			
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
			
			// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			wrapSelectionMove : true,
			
			// 사용자가 추가한 새행은 softRemoveRowMode 적용 안함. 
			// 즉, 바로 삭제함.
			// softRemovePolicy : "exceptNew"
			
			// 정렬 사용
			enableSorting : true,
			
			// 칼럼 이동 가능 설정(헤더 드래그)
			// enableMovingColumn : true,
			
			// footer 영역 표시
			// showFooter : true
			
	};

	// 실제로 #grid_wrap 에 그리드 생성
	myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
	
	
	// cellEditCancelHandler 이벤트 바인딩 : 행 추가 시 name을 입력하지 않으면 삭제 
	AUIGrid.bind(myGridID, "cellEditCancel", cellEditCancelHandler);
	
	// 행 추가 이벤트 바인딩 : 행 추가 시 추가된 행에 선택자가 이동
	AUIGrid.bind(myGridID, "addRowFinish", auiAddRowHandler);
	
	// 행 삭제 이벤트 바인딩 
	// AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
	
};

/// cellEditCancelHandler 이벤트 바인딩
function cellEditCancelHandler(event) {
	if(event.dataField == "name") {
		// 학생 이름 입력 안하면 삭제.
		if(event.item.name == "") {
			// removeRow 메소드는 에디팅이 현재 열린 경우 취소를 시키게 됨.
			// 이 때 다시 취소 이벤트가 발생하여 무한으로 빠지는 것을 방지
			setTimeout(function() {
				AUIGrid.removeRow(myGridID, event.rowIndex);
			},16);
		}
	}
};

	
//행 추가, 삽입
function addRow() {
	
	// 행 추가 시 위치
	// var rowPos = document.getElementById("btn_addRow").value;
	
	var item = new Object();
	
	// rowIdField 로 지정한 id 는 그리드가 row 추가 시 자동으로 중복되지 않게 생성합니다.
	// DB 에서 Insert 시 실제 PK 값 결정하십시오.
	
	item.name = "";
	
	console.log(item);
	
	/* "code": "CJU",
    "name": "제주항 연안여객선터미널",
    "abbreviation": "제주",
    "address": "서울특별시 서초구",
    "fee": "상세 보기",
    "unloader_name": "석포물류",
    "phone": "010-1111-2222",
    "unloader_date": "2014-10-01" */
	
	// parameter
	// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
	// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
	AUIGrid.addRow(myGridID, item, "last");
};


//addRowFinish 이벤트 핸들링
function auiAddRowHandler(event) {
	
	// 행 추가 시 추가된 행에 선택자가 이동합니다.
	// 이 때 칼럼은 기존 칼럼 그대로 유지한채 이동함.
	// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
	var selected = AUIGrid.getSelectedIndex(myGridID);
	
	console.log("selected : " + selected);
	
	if(selected.length <= 0) {
		return;
	}
	
	var rowIndex = selected[0];
	var colIndex = AUIGrid.getColumnIndexByDataField(myGridID, "name");
	AUIGrid.setSelectionByIndex(myGridID, rowIndex, colIndex); // name 으로 선택자 이동

	// 빈행 추가 후 isbn 에 인푸터 열기
	AUIGrid.openInputer(myGridID);
};


// 행 삭제
function removeRow() {
	AUIGrid.removeRow(myGridID, "selectedIndex");
}

// 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
function restoreSoftRow() {
	// 선택 행 삭제 취소(선택 행이 삭제 됐다면...)
	AUIGrid.restoreSoftRows(myGridID, "selectedIndex");
}

// 삭제해서 마크 된(줄이 그어진) 행을 그리드에서 제거 합니다.
function removeSoftRows() {
	
	// 삭제 처리된 아이템 있는지 보기
	var removedRows = AUIGrid.getRemovedItems(myGridID, true);
	
	console.log(removedRows);
	
	if(removedRows.length <= 0) {
		alert("삭제 처리되어 마크된 행이 없습니다.")
		return;
	}
	
	// softRemoveRowMode 가 true 일 때 삭제를 하면 그리드 상에 마크가 되는데
	// 이를 실제로 그리드에서 삭제 함.
	if(confirm("다시 복구 할 수 없습니다. 삭제 하시겠습니까?")) {
		AUIGrid.removeSoftRows(myGridID);
	}
}
	
	
	
</script>


</head>
<body>
	<h3>그리드 생성</h3>

		<div>
			<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
			<div id="grid_wrap" style="width:940px; height:350px; margin:0 auto;"></div>
			
		</div>
		
		<br>
		
			<div id="div_1">
				<button class="btn" onclick="addRow()">추가</button>
				<button class="btn" onclick="removeRow()">삭제</button>
				<button class="btn" onclick="restoreSoftRow()">삭제 취소</button>
				<button class="btn" onclick="removeSoftRows()">완전 삭제</button>
			</div>
			
			<div id="div_2">
				<button class="btn" onclick="saveColumnLayout()">저장</button>
				<button class="btn" onclick="resetColumnLayout()">초기화</button>
			</div>
			
			<p id="p1">*삭제 시 softRemoveRowMode = true 설정으로 바로 그리드에서 제거하지 않고 삭제 처리, 완전 삭제 가능</p>
		
		
		
		
		<!--
		<div class="desc_bottom">
			<p id="ellapse"></p>
		</div>
		-->


</body>
</html>