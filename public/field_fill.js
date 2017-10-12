function fields_filled(fields, data){
	for (f in fields){
	var field_id = '#'+ fields[f];
	var field_val = data[fields[f]];
	$(field_id).text(field_val);
	}
}
