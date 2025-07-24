package com.nichanlabs.medlink.model;

import lombok.*;
import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "medical_tests")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MedicalTest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String testType; // Biologie, Radiologie, etc.

    private String testName;
    private String result;
    private String filePath; // Pour stocker le chemin du fichier uploadé
    private LocalDate testDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
}