package com.nichanlabs.medlink.repository;

import com.nichanlabs.medlink.model.MedicalTest;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MedicalTestRepository extends JpaRepository<MedicalTest, Long> {
    List<MedicalTest> findByPatientId(Long patientId);
    List<MedicalTest> findByPatientIdAndTestType(Long patientId, String testType);
}