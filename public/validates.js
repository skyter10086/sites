

(function($) {  
$.extend($.fn.combobox.defaults.rules, {
        selectValueRequired: {
            validator: function(){
				var _value = $(this).combobox('getValue');
                var opt = $(this).combobox('options');
                var _data = $(this).combobox('getData');
               
                var _b = false;
                for (var i = 0; i < _data.length; i++) {  
					if (_data[i][opt.valueField] == _value) {  
					_b=true;  
					break;
					}  
				}  
				if(!_b){  
					$(param).combobox('setValue', '');  
				}  
                //return $(param[0]).find("option:contains('"+value+"')").val() != '';
                return _b;
            },
            message: '请输入选项内的值.'
        },
        fileValueRequired: {
		validator: function(value,param){
			var f = $(this).next().find(':file').get(0).files[0];
			if (f.size == 0) {
			$(this).filebox('setValue','');
			}
			return f.size != 0;
		},
		message: '文件内容不得为空'
	   },
	   extFilter: {
	       validator: function(value, param){
		       var filename = $(this).filebox('getValue');
		       var re = /\.csv$/i;
		       return re.test(filename);
	       },
	       message: '文件格式不对'
	   }
    });
})(jQuery); 
