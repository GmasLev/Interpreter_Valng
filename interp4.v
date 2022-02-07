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
	tokens				map[string]string
	linea				int
	columna				int
	mapa				map[string]string
}

fn (mut this Magenta) constructor(code string) {
	this.codes = code
	this.lon = this.codes.len 
}
fn (mut this Magenta) tokenize() ? {
	this.pos = 0
	this.linea = 1
	this.columna = 0
	this.currentchar = this.codes[this.pos]
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
				//this.mapa['error'] = 'Unterminated string at line $this.linea column $this.columna'
				return error('Unterminated string at line $this.linea column $this.columna')
			}
			this.pos++
			this.columna++
			this.tokens['type'] = 'string'
			this.tokens['value'] = this.res
			println(this.tokens)
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
			this.tokens['type'] = if this.res in this.keyword {"keyword"} else {"keyword_custom"}
			this.tokens['value'] = this.res
			println(this.tokens)
			this.res = ''
		}else if this.currentchar == `=` {	 
			this.pos++
			this.columna++
			this.tokens['type'] = 'operator'
			this.tokens['value'] = 'eq'
			println(this.tokens)
		}else{
			//this.mapa['error'] = 'Unexpected character ${this.codes[this.pos]} at line ${this.linea} column ${this.columna}'
			return error('Unexpected character ${this.codes[this.pos].ascii_str()} at line ${this.linea} column ${this.columna}')
		}
	} 
	//this.mapa['error'] = 'false'
}

fn main() {
	mut code :='println "hello world" var msg < "SECRET message" println msg'
	
	mut mag := &Magenta{}		
	mag.constructor(code)
	mag.tokenize()?
}

