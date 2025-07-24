package com.nichanlabs.medlink.dto;

import lombok.Data;
import java.util.Date;
import java.util.Set;

@Data
public class PatientDto {
    private Long id;
    private String username;
    private String firstName;
    private String lastName;
    private Date dateOfBirth;
    private String insuranceNumber;
    private Set<String> comorbidities;
    private Double weight;
    private Double height;
}