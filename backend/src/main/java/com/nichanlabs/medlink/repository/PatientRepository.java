package com.nichanlabs.medlink.repository;

import com.nichanlabs.medlink.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByUsername(String username);
    Boolean existsByUsername(String username);
}