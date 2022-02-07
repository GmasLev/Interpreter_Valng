
struct Mapa {
	mut:
	mapa		[]map[string]string
}

fn main() {
	mut m := &Mapa{}
	m.constructor()
	println(m.mapa)
}

fn (mut m Mapa) constructor() {
	m.mapa << {'type': 'keyword_custom', 'value': 'msg'}
	m.mapa << {'type': 'operator', 'value': 'eq'}
	m.mapa << {'type': 'string', 'value': 'no entiendo'}
}