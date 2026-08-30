package cl.duoc.jv0101.caso05.delivery;

import org.junit.jupiter.api.Test;
import cl.duoc.jv0101.caso05.delivery.config.OpenApiConfig;

import static org.assertj.core.api.Assertions.assertThat;

class OpenApiConfigTest {

    @Test
    void beanOpenApiGenerado() {
        assertThat(new OpenApiConfig().customOpenAPI()).isNotNull();
    }
}
