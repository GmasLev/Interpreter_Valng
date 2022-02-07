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
	keyword				[]string = ["print", "var"]
	varchars 			string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
	currentchar			byte = `\n`
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
	println(this.codes)
}
fn (mut this Magenta) tokenize()  {
	this.pos = 0
	this.linea = 1
	this.columna = 0
	for this.pos < this.lon {
		this.currentchar = this.codes[this.pos]
		mut cc := this.currentchar.ascii_str()			//ascii2char(this.currentchar).ascii_str()
		println(cc)
		println(this.res)
		mut ch := ascii2str(`p`)
		println(ch)
		break
		if this.currentchar == 32 {			// ` ` == 32
			this.pos++
			this.columna++
			continue
		}else if this.currentchar == `\n` || this.currentchar == `\t` {	// `\n` == 10
			this.linea++
			this.columna = 0
			this.pos++
			continue
		}else if this.currentchar == 34 {	// `"` == 34
			this.pos++
			this.columna++
			println(this.codes[this.pos])
			break
			for this.codes[this.pos] != 34 && this.pos < this.lon {
				this.res += this.codes[this.pos].str()
				this.pos++
				this.columna++
			}
			if this.codes[this.pos] != 34 {
				this.mapa['error'] = 'Unterminated string at line $this.linea column $this.columna'
			}
			this.pos++
			this.columna++
			this.tokens['type'] = 'string'
			this.tokens['value'] = this.res
		}else if this.varchars.contains(this.currentchar.str()) {
			this.res = this.currentchar.str()
			println(this.res)
			break
			this.pos++
			this.columna++
			for this.varchars.contains(this.codes[this.pos].str()) && this.pos < this.lon {
				this.res += this.codes[this.pos].str()
				this.pos++
				this.columna++
			}
			this.tokens['type'] = if this.res in this.keyword {"keyword"} else {"keyword_custom"}
			this.tokens['value'] = this.res
		}else if this.currentchar == 61 {	// `=` == 61 
			this.pos++
			this.columna++
			this.tokens['type'] = 'operator'
			this.tokens['value'] = 'eq'
		}else{
			this.mapa['error'] = 'Unexpected character ${this.codes[this.pos]} at line ${this.linea} column ${this.columna}'
		}
	}
	this.mapa['erros'] = 'false'
}

fn ascii2str(c byte) string {
	if c == `a` { return 'a' }
	else if c == `b` { return 'b' }
	else if c == `c` { return 'c' }
	else if c == `d` { return 'd' }
	else if c == `e` { return 'e' }
	else if c == `f` { return 'f' }
	else if c == `g` { return 'g' }
	else if c == `h` { return 'h' }
	else if c == `i` { return 'i' }
	else if c == `j` { return 'j' }
	else if c == `k` { return 'k' }
	else if c == `l` { return 'l' }
	else if c == `m` { return 'm' }
	else if c == `n` { return 'n' }
	else if c == `o` { return 'o' }
	else if c == `p` { return 'p' }
	else if c == `q` { return 'q' }
	else if c == `r` { return 'r' }
	else if c == `s` { return 's' }
	else if c == `t` { return 't' }
	else if c == `u` { return 'u' }
	else if c == `v` { return 'v' }
	else if c == `w` { return 'w' }
	else if c == `x` { return 'x' }
	else if c == `y` { return 'y' }
	else { return 'z' }
}

fn ascii2char(c int) byte {
	if c == 112 { return `p` }
	else if c == 114 { return `r` }
	else if c == 105 { return `i` }
	else if c == 110 { return `n` }
	else if c == 116 { return `t` }
	else if c == 118 { return `v` }
	else if c == 97 { return `a` }
	else if c == 122 { return `z` }
	else if c == 95 { return `_` }
	else if c == 99 { return `c` }
	else if c == 100 { return `d` }
	else if c == 101 { return `e` }
	else if c == 102 { return `f` }
	else if c == 103 { return `g` }
	else if c == 104 { return `h` }
	else if c == 106 { return `j` }
	else if c == 107 { return `k` }
	else if c == 108 { return `l` }
	else if c == 109 { return `m` }
	else if c == 111 { return `o` }
	else if c == 113 { return `q` }
	else if c == 115 { return `s` }
	else if c == 119 { return `w` }
	else if c == 120 { return `x` }
	else if c == 121 { return `y` }
	else { return `z` }
}

fn main() {
	mut code := 
				'print \"hello world\"
				var msg = \"secret message\"
				print msg'

	mut mag := Magenta{}		
	mag.constructor(code)
	println(mag.keyword)
	println(mag.lon)
	mag.tokenize()
	
}

