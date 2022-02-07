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
	tokens				[]string
	linea				int
	columna				int
	res					string
}

fn (mut this Magenta) constructor(code string) {
	this.codes = code
	println(this.codes)
}
fn (mut this Magenta) tokenize() {
	this.len = this.codes.len
	this.pos = 0
	this.linea = 1
	this.columna = 0

}

fn main() {
	mut code := 'a poco imprime! println(\'test\')'
	mut imprime := &Magenta{}		// ["print", "var"],'',code,0,0,['a'],0,0,''
	imprime.constructor(code)
	println(imprime.keyword)
	imprime.tokenize()
	println(imprime.len)
}

