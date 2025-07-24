package com.nichanlabs.medlink.dto;

import lombok.Data;
import javax.validation.constraints.*;
import java.util.Date;
import java.util.Set;

@Data
public class SignUpRequest {
    @NotBlank
    @Size(min = 3, max = 15)
    private String username;

    @NotBlank
    @Size(min = 6, max = 20)
    private String password;

    @NotBlank
    private String firstName;

    @NotBlank
    private String lastName;

    private Date dateOfBirth;
    private String insuranceNumber;
    private Set<String> comorbidities;
    private Double weight;
    private Double height;
}