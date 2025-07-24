package com.nichanlabs.medlink.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AppointmentDto {
    private Long id;
    private String title;
    private String description;
    private LocalDateTime appointmentDate;
    private boolean reminderSet;
    private Long patientId;
}