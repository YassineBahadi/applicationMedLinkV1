package com.nichanlabs.medlink.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "patients")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;

    private String insuranceNumber;

    @ElementCollection
    @CollectionTable(name = "patient_comorbidities", joinColumns = @JoinColumn(name = "patient_id"))
    @Column(name = "comorbidity")
    private Set<String> comorbidities = new HashSet<>();

    private Double weight; // in kg
    private Double height; // in cm

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Medication> medications = new HashSet<>();

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<ClinicalData> clinicalData = new HashSet<>();

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MedicalTest> medicalTests = new HashSet<>();

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Appointment> appointments = new HashSet<>();
}