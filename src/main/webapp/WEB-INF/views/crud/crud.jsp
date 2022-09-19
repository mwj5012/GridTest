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
	
	
	<style type="text/css">
	/* 커스텀 셀 스타일 정의 */
	.mycustom-n {
	background : #eeeeee;
	color:#000;
	}
	.mycustom-t {
	background : #53C14B;
	color:#000;
	}
	.mycustom-u {
	background : #DE4F4F;
	color:#000;
	}
	.mycustom-e {
	background : #F2CB61;
	color:#000;
	}
	.mycustom-p {
	background : #FFF29E;
	color:#000;
	}
	
	.legend {
		display:inline-block;
		text-align:center;
		width:30px;
		margin: 0.5em;
		padding: 0.25em;
	}
	
	.custmom-bar {
		border:1px solid #E4E4E4;
		background: #008299;
		background: -webkit-linear-gradient(left, #5CD1E5, #008299);
		background: -moz-linear-gradient(left, #5CD1E5, #008299);
		background: -ms-linear-gradient(left, #5CD1E5, #008299);
		background: -o-linear-gradient(left, #5CD1E5, #008299);
		background: linear-gradient(to right, #5CD1E5, #008299);
	}
	</style>
	
	
	<script type="text/javascript">
	// AUIGrid 생성 후 반환 ID
	var myGridID;
	
	// 푸터 데이터
	var footerLayout = [{ 
		labelText : "합 계",
		positionField : "name"
	}, {
		dataField : "ct",
		operation : "SUM",
		positionField : "ct"
	}, { 
		dataField : "ce",
		operation : "SUM",
		positionField : "ce"
	}, { 
		dataField : "cu",
		operation : "SUM",
		positionField : "cu"
	}, { 
		dataField : "cp",
		operation : "SUM",
		positionField : "cp"
	}, {
		dataField : "ceu",
		operation : "SUM",
		positionField : "ceu"
	}];
	
	// document ready (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
	function documentReady() {  
		
		var columnLayout = createColumnData();
	
		// AUIGrid 그리드를 생성합니다.
		createAUIGrid(columnLayout);
		
		// 데이터 요청, 요청 성공 시 AUIGrid 에 데이터 삽입합니다.
		requestData("./../resources/samples/data/student_present.json");
	
	};
	
	// 칼럼 레이아웃을 생성하여 반환합니다.
	function createColumnData() {
		var columnLayout = [{
			dataField: "name",
			headerText: "학생이름",
			filter : {
				showIcon : true,
				useExMenu : true
			}
		}];
				
		var obj = { headerText : "합 계", 
				children : [
				   { dataField : "ct", expFunction : myExpFunction, editable : false, headerText : "T", width:40, headerStyle : "mycustom-t", dataType:"numeric", headerTooltip : { show:true, tooltipHtml : "지각" } },
				   { dataField : "ce", expFunction : myExpFunction, editable : false,  headerText : "E", width:40, headerStyle : "mycustom-e", dataType:"numeric",  headerTooltip : { show:true, tooltipHtml : "사정 상 결석" } },
				   { dataField : "cu", expFunction : myExpFunction, editable : false,  headerText : "U", width:40, headerStyle : "mycustom-u", dataType:"numeric",  headerTooltip : { show:true, tooltipHtml : "무단 결석" } },
				   { dataField : "cp", expFunction : myExpFunction, editable : false,  headerText : "P", width:40, headerStyle : "mycustom-p", dataType:"numeric",  headerTooltip : { show:true, tooltipHtml : "출석" } },
				   { dataField : "ceu", expFunction : myExpFunction, editable : false,  headerText : "결석 일수", width:100,  dataType:"numeric", renderer : {	type : "BarRenderer", max : 10, style : "custmom-bar" }} ]};
		columnLayout.push(obj);
	
		var days = ["일", "월", "화", "수", "목", "금", "토"];
		for(var i=1; i<=31; i++) {
			obj = {};
			obj.headerText = days[i%7];
			obj.children = [ { dataField : "d" + i,
				headerText : i, 
				width:40,
				styleFunction : cellStyleFunction
			} ];
			columnLayout.push(obj);
		}
	
		return columnLayout;
	}
	
	// AUIGrid 를 생성합니다.
	function createAUIGrid(columnLayout) {
		
		var auiGridProps = {
			editable : true,
			editableOnFixedCell : true,
			rowIdField : "no",
			enableFilter : true,
			showFooter : true,
			useContextMenu : true,
			showStateColumn : true,
			fixedColumnCount : 1,
			softRemovePolicy : "exceptNew",
			skipReadonlyColumns : true,
			enterKeyColumnBase :true
		};
	
		// 실제로 #grid_wrap 에 그리드 생성
		myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
		
		// cellEditEndBefore 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditEndBefore", cellEditEndBeforeHandler);
		
		AUIGrid.bind(myGridID, "cellEditCancel", cellEditCancelHandler);
		
		// 행추가 이벤트 바인딩
		AUIGrid.bind(myGridID, "addRowFinish", auiAddRowHandler);
		
		// 푸터 레이아웃 세팅
		AUIGrid.setFooter(myGridID, footerLayout);
	}
	
	// 셀스타일 함수 정의
	function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) {
		if(value == "N")
			return "mycustom-n";
		else if(value == "T")
			return "mycustom-t";
		else if(value == "U")
			return "mycustom-u";
		else if(value == "E")
			return "mycustom-e";
		else if(value == "P")
			return "mycustom-p";
		return null;
	};
	
	// 행 아이템에서 T, E, U, P 개수를 구하는 수식 함수.
	function myExpFunction (rowIndex, columnIndex, item, dataField ) {
		var count = 0;
		var value;
		var field;
		var opValue;
		
		if(dataField == "ceu") { // E, U 개수 구하기
			for(field in item) {
				value = item[field];
				if(value == "E" || value == "U") {
					count++;
				}
			}
			return count;
		} else { // T, E, U, P 각각 개별 개수 구하기
			switch(dataField) {
			case "ct": // 지각 합
				opValue = "T";
				break;
			case "ce": // 사정상 결적 합
				opValue = "E";
				break;
			case "cu": // 무단 결석 합
				opValue = "U";
				break;
			case "cp": // 출석 합
				opValue = "P";
				break;
			}
			for(field in item) {
				value = item[field];
				if(value == opValue) {
					count++;
				}
			}
			return count;
		}
		
		return 0;
	};
	
	// cellEditEndBefore 이벤트에서 사용자가 입력한 텍스트를 강제로 변경가능합니다.
	function cellEditEndBeforeHandler(event) {
		
		// 이름은 어떤것을 입력해도 허용함.
		if(event.dataField == "name") {
			document.getElementById("editing_info").innerHTML = "oldValue : " + event.oldValue + ", new Value : " + event.value;
			return event.value;
		}
		
		var value = event.value;
		var oldValue = event.oldValue;
		var validValues = ["T", "E", "U", "P", "N"]; // 입력 유효값.
		
		if(!value)
			return oldValue;
		
		// 대문자로 모두 변경시킴
		value = value.toUpperCase();
		
		// T, E, U, P, N 이 아니라면 에디팅 취소와 같음
		if(validValues.indexOf(value) == -1) {
			document.getElementById("editing_info").innerHTML = "T, E, U, P, N 입력이 아님으로 에디팅 취소시킴";
			return oldValue;
		}
		
		document.getElementById("editing_info").innerHTML = "oldValue : " + oldValue + ", new Value : " + value + ", (대문자로 변경됨)";
		
		return value;
	};
	
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
	
	// 행 추가, 삽입
	function addRow() {
		
		// 그리드의 편집 인푸터가 열린 경우 에디팅 완료 상태로 만듬.
		AUIGrid.forceEditingComplete(myGridID, null);
		
		var item = new Object();
		var holidays = [6, 7, 13, 14];
		item.name = "";
		for(var i=1; i<=31; i++) {
	
			if(holidays.indexOf(i) >= 0){
				item[ "d" + i ] = "N";
			} else {
				item[ "d" + i ] = "P";
			}
		}
		AUIGrid.addRow(myGridID, item, "last");
	}
	
	// addRowFinish 이벤트 핸들링
	function auiAddRowHandler(event) {
		// 행 추가 시 추가된 행에 선택자가 이동합니다.
		// 이 때 칼럼은 기존 칼럼 그대로 유지한채 이동함.
		// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
		var selected = AUIGrid.getSelectedIndex(myGridID);
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
	
	
	// 엑셀 내보내기(Export);
	function exportClick() {
		
		// 내보내기 실행
		AUIGrid.exportToXlsx(myGridID);
	};
	
	
	// PDF 내보내기(Export), AUIGrid.pdfkit.js 파일을 추가하십시오.
	function exportPdfClick() {
		
		// 완전한 HTML5 를 지원하는 브라우저에서만 PDF 저장 가능( IE=10부터 가능 )
		if(!AUIGrid.isAvailabePdf(myGridID)) {
			alert("PDF 저장은 HTML5를 지원하는 최신 브라우저에서 가능합니다.(IE는 10부터 가능)");
			return;
		}
		
		// 내보내기 실행
		AUIGrid.exportToPdf(myGridID, {
			// 폰트 경로 지정
			fontPath : "./pdfkit_20220714/jejugothic-regular.ttf"
		});
	};
	</script>
	
	
</head>
<body>
	<div><a href="/grid">Home</a></div>

	<h3>CRUD 테스트</h3>
	
	
	
	<div id="main">
		<div class="desc">
			<span class="btn" style="float:right;" onclick="exportClick()">엑셀(xlsx)로 저장</span>
			<span class="btn" style="float:right;" onclick="exportPdfClick()">PDF로 저장</span>
			<p style="clear:both;">학생 출석 레코드를 표현 할 때 각각의 셀에 스타일을 적용시킨 것입니다.</p>
			<ul class="nav_u">
				<li><span class="legend mycustom-t">T</span><span>지각</span></li>
				<li><span class="legend mycustom-e">E</span><span>유고</span></li>
				<li><span class="legend mycustom-u">U</span><span>무단</span></li>
				<li><span class="legend mycustom-p">P</span><span>출석</span></li>
				<li><span class="legend mycustom-n">N</span><span>휴교</span></li>
			</ul>
			
			<p>날짜의 값(T, E, U, P, N) 수정 시 동적으로 합계가 변경됩니다.</p>
			
			<div>
				<span> <button class="btn" onclick="addRow()">학생 추가</button></span>
				<span> <button  class="btn" onclick="removeRow()">선택 삭제</button></span>
				<span> <button  class="btn" onclick="restoreSoftRow()">삭제 취소</button></span>
				<span> <button  class="btn" onclick="removeSoftRows()">삭제 처리된 행들 완전 삭제</button></span>
				<p>(삭제 시 softRemoveRowMode = true 설정으로 바로 그리드에서 제거하지 않음.)</p>
			</div>
			
		</div>
		<div>
			<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
			<div id="grid_wrap" style="width:1200px; height:480px; margin:0 auto;"></div>
		</div>
		<div class="desc_bottom">
			<p>에디팅 적용 전 검사(cellEditEndBefore) : <span id="editing_info"></span></p>
			
		</div>
	</div>

</body>
</html>