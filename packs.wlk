class Pack {
  const duracion
  const precioBase
  const beneficios =#{}
  var  coordinador

  method esPremium()
  method duracion() = duracion
  method precioBase() =precioBase
  method beneficios() = beneficios
  method coordinador() = coordinador
  method coordinador(unCoordinador) {
    coordinador = unCoordinador
  } 
  method beneficiosVigentes() = beneficios.filter({b=>b.estaVigente()}) 
  method costoFinal()=
    precioBase + self.beneficiosVigentes().sum({b=>b.costo()})
}
class PackNacional inherits Pack{
  var provincia
  const actividades =#{}

  method provincia() =provincia
  method actividades() =actividades
  method provincia(unaProvincia) {
    provincia = unaProvincia
  }
  override method esPremium() = duracion > 10 && 
    coordinador.estaCalificado()
}
class PackInternacional inherits Pack {
  var destino
  var cantEscalas 
  var esDeInteres 
  
  method destino() = destino
  method destino(unDestino) {
    destino = unDestino
  }
  method cantEscalas() = cantEscalas
  method aumentarEscalas(unNumero) {
    cantEscalas += unNumero
  }
  method decrementarEscalas(unNumero) {
    cantEscalas -= unNumero
  }
  method esDeInteres() = esDeInteres
  method siEsDeInteres() {
    esDeInteres = true
  }
  method noEsDeInteres() {
    esDeInteres = false 
  }
  override method costoFinal() =
    super() * (1 + 0.20)
  override method esPremium() = self.esDeInteres() && 
    duracion > 20 && cantEscalas == 0
}
class PackProvinciales inherits PackNacional {
  const ciudadesAVisitar

  method ciudadesAVisitar() = ciudadesAVisitar
  override method esPremium()= actividades.size() >=4 &&
    ciudadesAVisitar > 5 &&
    self.beneficiosVigentes().size() >= 3
  override method costoFinal() =super() * self.precioExtraPremium()
  method precioExtraPremium() {
    return if(self.esPremium()){
      1.5
    }else{
      1
    }
  }
}
class Coordinadores {
  const viajesRealizados
  const motivado
  const aniosDeExperencia
  var rolActual
  const rolesValidos = #{guia, asistenteLogistico, acompaniante}

  method viajesRealizados() = viajesRealizados
  method motivado() = motivado
  method aniosDeExperencia() =aniosDeExperencia
  method rolActual() = rolActual  
  method cambiarRol(unRol) {
    if(!rolesValidos.contains(unRol)){
      self.error("Rol Invalido")
    }else{
      rolActual = unRol
    }
  }
  method rolesValidos() = rolesValidos 
  method estaCalificado() = viajesRealizados > 20 && 
    rolActual.condicionaAdicional(self)
}
object guia {
  method condicionaAdicional(coordinador) = coordinador.motivado()
}
object asistenteLogistico {
  method condicionaAdicional(coordinador) = coordinador.aniosDeExperencia()>=3
}
object acompaniante {
  method condicionaAdicional(coordinador) = true
}
class Beneficios {
  const tipo = #{}
  var costo
  var estaVigente

  method agregarTipo(unTipo) {
    tipo.add(unTipo)
  }
  method tipo() = tipo 
  method estaVigente() = estaVigente 
  method costo() = costo 
  method costo(unCosto) {
    costo = unCosto.estaVigente()
  }
  method esVigente() {
    estaVigente = true
  }
  method dejaDeSerVigente() {
    estaVigente = false
  }
}