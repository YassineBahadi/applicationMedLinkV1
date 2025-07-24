package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.MedicationDto;
import com.nichanlabs.medlink.security.CurrentUser;
import com.nichanlabs.medlink.security.UserPrincipal;
import com.nichanlabs.medlink.service.MedicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/medications")
public class MedicationController {

    @Autowired
    private MedicationService medicationService;

    @GetMapping
    @PreAuthorize("hasRole('USER')")
    public List<MedicationDto> getAllMedicationsByPatientId(@CurrentUser UserPrincipal currentUser) {
        return medicationService.getAllMedicationsByPatientId(currentUser.getId());
    }

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public MedicationDto createMedication(@CurrentUser UserPrincipal currentUser,
                                          @Valid @RequestBody MedicationDto medicationDto) {
        return medicationService.createMedication(currentUser.getId(), medicationDto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public MedicationDto updateMedication(@CurrentUser UserPrincipal currentUser,
                                          @PathVariable(value = "id") Long medicationId,
                                          @Valid @RequestBody MedicationDto medicationDto) {
        return medicationService.updateMedication(currentUser.getId(), medicationId, medicationDto);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> deleteMedication(@CurrentUser UserPrincipal currentUser,
                                              @PathVariable(value = "id") Long medicationId) {
        medicationService.deleteMedication(currentUser.getId(), medicationId);
        return ResponseEntity.ok().build();
    }
}