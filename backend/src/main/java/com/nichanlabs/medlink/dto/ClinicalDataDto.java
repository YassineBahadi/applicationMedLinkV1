package com.nichanlabs.medlink.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ClinicalDataDto {
    private Long id;
    private String parameterType;
    private Double value;
    private LocalDateTime recordedAt;
    private Long patientId;
}