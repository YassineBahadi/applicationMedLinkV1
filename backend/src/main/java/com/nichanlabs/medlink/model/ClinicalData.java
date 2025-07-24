package com.nichanlabs.medlink.model;

import lombok.*;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "clinical_data")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClinicalData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String parameterType; // Poids, Tension, Glycémie, etc.

    private Double value;
    private LocalDateTime recordedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
}