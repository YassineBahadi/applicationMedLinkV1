package com.nichanlabs.medlink.repository;

import com.nichanlabs.medlink.model.ClinicalData;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ClinicalDataRepository extends JpaRepository<ClinicalData, Long> {
    List<ClinicalData> findByPatientId(Long patientId);
    List<ClinicalData> findByPatientIdAndParameterType(Long patientId, String parameterType);
}