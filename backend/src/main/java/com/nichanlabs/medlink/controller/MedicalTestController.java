package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.MedicalTestDto;
import com.nichanlabs.medlink.security.CurrentUser;
import com.nichanlabs.medlink.security.UserPrincipal;
import com.nichanlabs.medlink.service.MedicalTestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/medical-tests")
public class MedicalTestController {

    @Autowired
    private MedicalTestService medicalTestService;

    @GetMapping
    @PreAuthorize("hasRole('USER')")
    public List<MedicalTestDto> getAllMedicalTestsByPatientId(@CurrentUser UserPrincipal currentUser) {
        return medicalTestService.getAllMedicalTestsByPatientId(currentUser.getId());
    }

    @GetMapping("/{type}")
    @PreAuthorize("hasRole('USER')")
    public List<MedicalTestDto> getMedicalTestsByType(@CurrentUser UserPrincipal currentUser,
                                                      @PathVariable String type) {
        return medicalTestService.getMedicalTestsByType(currentUser.getId(), type);
    }

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public MedicalTestDto createMedicalTest(@CurrentUser UserPrincipal currentUser,
                                            @Valid @RequestBody MedicalTestDto medicalTestDto) {
        return medicalTestService.createMedicalTest(currentUser.getId(), medicalTestDto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public MedicalTestDto updateMedicalTest(@CurrentUser UserPrincipal currentUser,
                                            @PathVariable(value = "id") Long testId,
                                            @Valid @RequestBody MedicalTestDto medicalTestDto) {
        return medicalTestService.updateMedicalTest(currentUser.getId(), testId, medicalTestDto);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> deleteMedicalTest(@CurrentUser UserPrincipal currentUser,
                                               @PathVariable(value = "id") Long testId) {
        medicalTestService.deleteMedicalTest(currentUser.getId(), testId);
        return ResponseEntity.ok().build();
    }
}