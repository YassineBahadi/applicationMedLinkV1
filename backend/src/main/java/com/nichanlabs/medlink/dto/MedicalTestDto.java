package com.nichanlabs.medlink.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class MedicalTestDto {
    private Long id;
    private String testType;
    private String testName;
    private String result;
    private String filePath;
    private LocalDate testDate;
    private Long patientId;
}