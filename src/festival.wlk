class Carpa {

	var property limiteDePersonas
	var property tieneBanda
	const marca
	var genteEnLaCarpa = []

	method marca() = marca

	method entraPersona(persona) {
		if (self.dejaIngresar(persona)) {
			genteEnLaCarpa.add(persona)
		} else {
			self.error("no pueden ingresar mas personas")
		}
	}

	method genteEnLaCarpa() = genteEnLaCarpa

	method dejaIngresar(persona) = genteEnLaCarpa.size() < limiteDePersonas and not persona.estaEbria()

	method puedeIngresar(persona) = self.dejaIngresar(persona) and persona.quiereEntrarA(self)

	method cantidadEbriosEmpedernidos() = self.todosLosEbrios().filter({e => e.todasJarrasDe(1)}).size()

	method todosLosEbrios() = genteEnLaCarpa.filter({p => p.estaEbria()})
}

class Jarra {

	const litros
	const marca

	method cantidadDeAlcohol() = (litros * marca.graduacion()) / 100

	method litros() = litros
}

class Marca {

	var property gramosLupulo
	const origen

	method graduacion()
	
	method origen() = origen

}

class MarcaRubia inherits Marca {

	var graduacion

	override method graduacion() = graduacion

}

class MarcaNegra inherits Marca {

	override method graduacion() = graduacionReglamentariaNegra.graduacion().min(gramosLupulo * 2)

}

class MarcaRoja inherits MarcaNegra {

	override method graduacion() = super() * 1.25

}

class Persona {

	var property peso
	var property jarrasCompradas = []
	var property escuchaMusicaTradicional
	var property nivelAguante

	method estaEbria() = self.cantidadAlcoholIngerido() * peso > nivelAguante

	method cantidadAlcoholIngerido() = jarrasCompradas.sum({ jarra => jarra.cantidadDeAlcohol() })

	method comprarJarra(jarra) {
		jarrasCompradas.add(jarra)
	}

	method quiereEntrarA(unaCarpa) = self.leGustaLaMarcaDe(unaCarpa) and self.coincidePreferenciaMusicalDe(unaCarpa) and self.validarCantidadDePersonas(unaCarpa)

	method coincidePreferenciaMusicalDe(unaCarpa) = escuchaMusicaTradicional == unaCarpa.tieneBanda()

	method validarCantidadDePersonas(unaCarpa) = true

	method leGustaLaMarcaDe(unaCarpa) = true

	method todasJarrasDe(litros) = jarrasCompradas.all({j => j.litros() == litros})
	
	method esPatriota() = jarrasCompradas.all({j => j.origen() == self.nacionalidad()})
	
	method nacionalidad()
}

class Belga inherits Persona {

	override method leGustaLaMarcaDe(unaCarpa) = unaCarpa.marca().gramosLupulo() > 4
	
	override method nacionalidad() = "Belgica"

}

class Checo inherits Persona {

	override method leGustaLaMarcaDe(unaCarpa) = unaCarpa.marca().graduacion() > 0.8
	
	override method nacionalidad() = "Chequia"

}

class Aleman inherits Persona {

	override method validarCantidadDePersonas(unaCarpa) = unaCarpa.genteEnLaCarpa().size().even()
	
	override method nacionalidad() = "Alemania"

}

object graduacionReglamentariaNegra {

	var property graduacion = 0

}

