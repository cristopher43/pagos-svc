package cl.duoc.jv0101.caso05.delivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import cl.duoc.jv0101.caso05.delivery.model.Entrega;

public interface EntregaRepository extends JpaRepository<Entrega, Long> {
}
