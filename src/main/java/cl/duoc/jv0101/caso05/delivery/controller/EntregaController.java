package cl.duoc.jv0101.caso05.delivery.controller;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import cl.duoc.jv0101.caso05.delivery.model.Entrega;
import cl.duoc.jv0101.caso05.delivery.service.EntregaService;

@RestController
@RequestMapping("/api/entregas")
public class EntregaController {

    private final EntregaService service;

    public EntregaController(EntregaService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<Entrega>> listar() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Entrega> obtener(@PathVariable Long id) {
        return service.findById(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Entrega> crear(@Valid @RequestBody Entrega recurso) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(recurso));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Entrega> actualizar(@PathVariable Long id,
            @Valid @RequestBody Entrega datos) {
        return service.update(id, datos).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        return service.delete(id) ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
