package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.PatientDto;
import com.nichanlabs.medlink.security.CurrentUser;
import com.nichanlabs.medlink.security.UserPrincipal;
import com.nichanlabs.medlink.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/patient")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @GetMapping("/me")
    @PreAuthorize("hasRole('USER')")
    public PatientDto getCurrentPatient(@CurrentUser UserPrincipal currentUser) {
        return patientService.getCurrentPatient(currentUser);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public PatientDto getPatientById(@PathVariable(value = "id") Long patientId) {
        return patientService.getPatientById(patientId);
    }
}