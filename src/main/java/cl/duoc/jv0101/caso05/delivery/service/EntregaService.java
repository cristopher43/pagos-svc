package cl.duoc.jv0101.caso05.delivery.service;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import cl.duoc.jv0101.caso05.delivery.model.Entrega;
import cl.duoc.jv0101.caso05.delivery.repository.EntregaRepository;

@Service
public class EntregaService {

    private final EntregaRepository repository;

    public EntregaService(EntregaRepository repository) {
        this.repository = repository;
    }

    public List<Entrega> findAll() {
        return repository.findAll();
    }

    public Optional<Entrega> findById(Long id) {
        return repository.findById(id);
    }

    public Entrega create(Entrega recurso) {
        return repository.save(recurso);
    }

    public Optional<Entrega> update(Long id, Entrega datos) {
        return repository.findById(id).map(existente -> {
            existente.setNombre(datos.getNombre());
            existente.setRepartidor(datos.getRepartidor());
            existente.setEstado(datos.getEstado());
            return repository.save(existente);
        });
    }

    public boolean delete(Long id) {
        return repository.findById(id).map(existente -> {
            repository.delete(existente);
            return true;
        }).orElse(false);
    }
}
