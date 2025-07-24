package com.nichanlabs.medlink.repository;

import com.nichanlabs.medlink.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByPatientIdAndAppointmentDateAfter(Long patientId, LocalDateTime date);
}