package com.nichanlabs.medlink.dto;

import lombok.Data;
import java.time.LocalTime;
import java.util.Set;

@Data
public class MedicationDto {
    private Long id;
    private String name;
    private String dosage;
    private String form;
    private Integer timesPerDay;
    private Set<LocalTime> intakeTimes;
    private Long patientId;
}