function get_json(url,params){ 	
	var outdata;
$.ajax({
type : "get",
async:false,
dataType:"json",
url : url,
data:params,
success : function(data){
outdata = data;
},
error:function(e){
alert('ajax error');
}
});

return outdata; 	
		
			}
