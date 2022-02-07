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
	keyword				[]string = ["print", "var"]
	varchars 			string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
	mut:
	codes				string
	len					int
	pos					int
	tokens				map[string]string
	linea				int
	columna				int
	res					string
	mapa				map[string]string
}

fn (mut this Magenta) constructor(code string) {
	this.codes = code
	println(this.codes)
}
fn (mut this Magenta) tokenize()  {
	this.len = this.codes.len
	this.pos = 0
	this.linea = 1
	this.columna = 0
	for this.pos < this.len {
		mut currentchar := this.codes[this.pos]
		if currentchar == ` ` {
			this.pos++
			this.columna++
			continue
		}else if currentchar == `\n` {
			this.linea++
			this.columna = 0
			this.pos++
			continue
		}else if currentchar == `"` {
			//let res = ""
			this.pos++
			this.columna++
			for this.codes[this.pos] != `"` && this.pos < this.len {
				this.res += this.codes[this.pos].str()
				this.pos++
				this.columna++
			}
			if this.codes[this.pos] != `"` {
				this.mapa['error'] = 'Unterminated string at line $this.linea column $this.columna'
			}
			this.pos++
			this.columna++
			this.tokens['type'] = 'string'
			this.tokens['value'] = this.res
		}else if currentchar in this.varchars {
			this.res = currentchar
			this.pos++
			this.columna++
			for this.codes[this.pos] in this.varchars && this.pos < this.len {
				this.res += this.codes[this.pos].str()
				this.pos++
				this.columna++
			}
			this.tokens['type'] = if this.res in this.keyword {"keyword"} else {"keyword_custom"}
			this.tokens['value'] = this.res
		}
	}
}

fn main() {
	mut code := '
	a poco imprime! 
	println(\'test\')
	'
	mut imprime := &Magenta{}		// ["print", "var"],'',code,0,0,['a'],0,0,''
	imprime.constructor(code)
	println(imprime.keyword)
	imprime.tokenize()
	println(imprime.len)
}

