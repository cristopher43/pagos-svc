# language: es
Característica: Servicio Delivery (microservicio delivery del caso caso05)
  Los escenarios validan el contrato REST del microservicio alineado a sus endpoints.

  Escenario: el listado del recurso responde 200
    Dado el servicio "Delivery" está disponible
    Cuando consulto el listado de "entregas"
    Entonces el listado responde con código 200

  Escenario: ciclo de vida completo del recurso
    Dado un nuevo "entrega" con nombre "hola-cucumber"
    Cuando consulto el "entrega" recién creado
    Entonces el recurso tiene nombre "hola-cucumber" y código 200
    Cuando actualizo el "entrega" con nombre "cucumber-actualizado"
    Entonces el recurso queda con nombre "cucumber-actualizado" y código 200
    Cuando elimino el "entrega"
    Entonces la eliminación responde con código 204
    Y al consultar el "entrega" eliminado responde 404
