window.onload = function(e) {
	if(typeof document.querySelectorAll != "function") {
		document.getElementById("searchbox").style.display = "none";
		return;
	}
	document.getElementById("i_query").onkeyup = function(e){
		var value = String(this.value).toLowerCase();
		var trs = document.querySelectorAll("#summaryTableStyle tr");
		var v, id, count = 0;
		for(var i=0, len=trs.length; i<len; i++) {
			v = trs[i];
            if(id = v.getAttribute('id')) {
            	if(String(id).toLowerCase().indexOf(value) == -1)	{
            		v.style.display = "none";
            		count++;
            	} else {
            		v.style.display = "";
            	}
            }
		}
		if(count > 0) {
			document.getElementById("desc_top").style.display = "none";
		} else {
			document.getElementById("desc_top").style.display = "";
		}
	}
};
