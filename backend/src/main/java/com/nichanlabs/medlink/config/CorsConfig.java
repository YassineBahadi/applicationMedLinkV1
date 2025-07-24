package com.nichanlabs.medlink.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilterRegistrationBean() {
        CorsConfiguration config = new CorsConfiguration();

        // Autoriser les origines spécifiques (adaptez à vos besoins)
        config.addAllowedOrigin("http://localhost:3000"); // Frontend React
        config.addAllowedOrigin("http://localhost:4200"); // Frontend Angular

        // Pour la production:
        // config.addAllowedOrigin("https://votre-domaine.com");

        // Autoriser les credentials SEULEMENT si nécessaire (cookies/sessions)
        config.setAllowCredentials(false); // Mettez à true si vous utilisez des cookies

        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        FilterRegistrationBean<CorsFilter> bean = new FilterRegistrationBean<>(new CorsFilter(source));
        bean.setOrder(Ordered.HIGHEST_PRECEDENCE); // Priorité maximale
        return bean;
    }
}