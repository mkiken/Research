var unparser = require('./json2scala.js');
var fs = require("fs");
var names = [
'./log'
];
var name = names[0];
var json = fs.readFileSync(name, 'utf8');
// var json = JSON.stringify( { type: 'Empty' } );
 // var json = '{\
			  // "type": "StableId",\
			  // "contents": [\
				// {\
				  // "type": "Identifier",\
				  // "name": "java"\
				  // },\
				  // {\
				  // "type": "Identifier",\
				  // "name": "util"\
				  // },\
				  // {\
				  // "type": "Identifier",\
				  // "name": "Scanner"\
				  // }\
				  // ]\
				  // }';
				  // var json = '{\
				  // "type": "Identifier",\
				  // "name": "java"\
				  // }';
// var json = '{\
	// "type": "ImportStatement",\
		// "exprs": [\
		// {\
			// "type": "ImportExpr",\
				// "id": {\
					// "type": "StableId",\
						// "contents": [\
						// {\
							// "type": "Identifier",\
								// "name": "java"\
						// },\
					// {\
						// "type": "Identifier",\
							// "name": "util"\
					// },\
					// {\
						// "type": "Identifier",\
							// "name": "Scanner"\
					// }\
					// ]\
				// },\
			// "selector": null\
		// }\
	// ]\
// }'


// console.log(json); // {"key": "value"}
var contents = JSON.parse(json);
// var contents = '{type:"sss"}';

// console.log(contents);

unparser.convert(contents, 1); // 1:stdout




