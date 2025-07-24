package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.ClinicalDataDto;
import com.nichanlabs.medlink.security.CurrentUser;
import com.nichanlabs.medlink.security.UserPrincipal;
import com.nichanlabs.medlink.service.ClinicalDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/clinical-data")
public class ClinicalDataController {

    @Autowired
    private ClinicalDataService clinicalDataService;

    @GetMapping
    @PreAuthorize("hasRole('USER')")
    public List<ClinicalDataDto> getAllClinicalDataByPatientId(@CurrentUser UserPrincipal currentUser) {
        return clinicalDataService.getAllClinicalDataByPatientId(currentUser.getId());
    }

    @GetMapping("/{type}")
    @PreAuthorize("hasRole('USER')")
    public List<ClinicalDataDto> getClinicalDataByType(@CurrentUser UserPrincipal currentUser,
                                                       @PathVariable String type) {
        return clinicalDataService.getClinicalDataByType(currentUser.getId(), type);
    }

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ClinicalDataDto createClinicalData(@CurrentUser UserPrincipal currentUser,
                                              @Valid @RequestBody ClinicalDataDto clinicalDataDto) {
        return clinicalDataService.createClinicalData(currentUser.getId(), clinicalDataDto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ClinicalDataDto updateClinicalData(@CurrentUser UserPrincipal currentUser,
                                              @PathVariable(value = "id") Long dataId,
                                              @Valid @RequestBody ClinicalDataDto clinicalDataDto) {
        return clinicalDataService.updateClinicalData(currentUser.getId(), dataId, clinicalDataDto);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> deleteClinicalData(@CurrentUser UserPrincipal currentUser,
                                                @PathVariable(value = "id") Long dataId) {
        clinicalDataService.deleteClinicalData(currentUser.getId(), dataId);
        return ResponseEntity.ok().build();
    }
}