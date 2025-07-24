package com.nichanlabs.medlink.model;

import jakarta.persistence.*;
import lombok.*;
import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "medications")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Medication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String dosage;
    private String form;
    private Integer timesPerDay;

    @ElementCollection
    @CollectionTable(name = "medication_times", joinColumns = @JoinColumn(name = "medication_id"))
    @Column(name = "time")
    private Set<LocalTime> intakeTimes = new HashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
}