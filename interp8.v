/*
* Grammars or Rules:
*			 		keyword:	var keyword_custom op:eq String
*					keyword:	print String|var 
* Example:
*					print "hello world"
*					var msg = "secret message"
*					print msg
*/

struct Magenta {
	mut:
	keyword				[]string = ["print", "var","println"]
	varchars 			string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
	currentchar			byte = `A`
	res					string = 'magenta'
	codes				string
	lon					int
	pos					int
	linea				int
	columna				int
	tokens				[]map[string]string
	vars				map[string]string
}

fn (mut this Magenta) constructor(code string) {
	this.codes = code
	this.lon = this.codes.len 
}
fn (mut this Magenta) tokenize() ? {
	this.pos = 0
	this.linea = 1
	this.columna = 0
	lim := this.lon-1
	for this.pos < lim {
		this.currentchar = this.codes[this.pos]
		if this.currentchar == ` ` {		
			this.pos++
			this.columna++
			continue
		}else if this.currentchar == `\n` || this.currentchar == `\t` {	
			this.linea++
			this.columna = 0
			this.pos++
			continue
		}else if this.currentchar == `"` {	
			this.pos++
			this.columna++
			for this.pos <= lim && this.codes[this.pos] != `"` {
				this.res += this.codes[this.pos].ascii_str()
				this.pos++
				this.columna++
			}
			if this.codes[this.pos] != `"` {
				return error('Unterminated string at line $this.linea column $this.columna')
			}
			this.pos++
			this.columna++
			this.tokens << {'type': 'string', 'value': this.res} 
			this.res = ''
		}else if this.varchars.contains(this.currentchar.ascii_str()) {
			this.res = this.currentchar.ascii_str()
			this.pos++
			this.columna++
			for this.pos <= lim && this.varchars.contains(this.codes[this.pos].ascii_str()) {
				this.res += this.codes[this.pos].ascii_str()
				this.pos++
				this.columna++
			}
			key := if this.res in this.keyword {"keyword"} else {"keyword_custom"}
			this.tokens << {'type': key, 'value': this.res}
			this.res = ''
		}else if this.currentchar == `=` {	 
			this.pos++
			this.columna++
			this.tokens << {'type': 'operator', 'value': 'equal'}
			this.res = ''
		}else{
			return error('Unexpected character ${this.codes[this.pos].ascii_str()} at line ${this.linea} column ${this.columna}')
		}
	} 
	//return error('Out Range!')
}
fn (mut this Magenta) lexerize() ? {
	lim := this.tokens.len-1
	this.pos = 0
	for this.pos < lim {
		mut token := this.tokens[this.pos].clone()
		if token['type'] == "keyword" && token['value'] == "println" {
			//println(token)
			//if !(this.tokens[this.pos + 1]['type'] in this.keyword) {
			//	return error("Unexpected end of line, expected string")
			//}
			isvar := this.tokens[this.pos + 1]['type'] == "keyword_custom"
			isstring := this.tokens[this.pos + 1]['type'] == "string"
			if !isstring && !isvar {
				return error('Unexpected token ${this.tokens[this.pos + 1]['type']}, expected string')
			}
			if isvar {
				if !(this.tokens[this.pos + 1]['value'] in this.vars) {
					return error('Undefined variable ${this.tokens[this.pos + 1]['value']}')
				}
				println('${this.vars[this.tokens[this.pos + 1]['value']]}')
			}else{
				println('${this.tokens[this.pos + 1]['value']}')
			}
			this.pos += 2
		}else if token['type'] == "keyword" && token['value'] == "var" {
			//println(token)
			iscustomkw := this.tokens[this.pos + 1]['type'] == "keyword_custom"
			//println(iscustomkw)
			if !iscustomkw {
				if !(this.tokens[this.pos + 1] in this.tokens) {
					return error("Unexpected end of line, expected variable name")
				}
				return error('Unexpected token ${this.tokens[this.pos + 1]['type']}, expected variable name')
			}
			mut varname := this.tokens[this.pos + 1]['value']
			//println(varname)
			iseq := this.tokens[this.pos + 2]['type'] == "operator" && this.tokens[this.pos + 2]['value'] == "equal"
			//println(iseq)
			if !iseq {
				if !(this.tokens[this.pos + 2] in this.tokens) {
					return error("Unexpected end of line, expected =")
				}
				return error('Unexpected token ${this.tokens[this.pos + 1]['type']}, expected =')
			}

			isstring := this.tokens[this.pos + 3]['type'] == "string"
			if !isstring {
				if !(this.tokens[this.pos + 3] in this.tokens) {
					return error("Unexpected end of line, expected string")
				}
				return error('Unexpected token ${this.tokens[this.pos + 1]['type']}, expected string')
			}

			if varname in this.vars {
				return error('Variable ${varname} already exists')
			}
			this.vars[varname] = this.tokens[this.pos + 3]['value']
			this.pos += 4
		}else{
			return error('Unexpected token ${token['type']}')
		}
	}
}

fn main() {
	mut code := 'println "hello world" var msg = "SECRET Number:AoGB" println msg'
	
	mut mag := &Magenta{}		
	mag.constructor(code)
	mag.tokenize()?
	mag.lexerize()?
}

