package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.PatientDto;
import com.nichanlabs.medlink.exception.ResourceNotFoundException;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.PatientRepository;
import com.nichanlabs.medlink.security.UserPrincipal;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ModelMapper modelMapper;

    public PatientDto getCurrentPatient(UserPrincipal currentUser) {
        Patient patient = patientRepository.findById(currentUser.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", currentUser.getId()));

        return modelMapper.map(patient, PatientDto.class);
    }

    public PatientDto getPatientById(Long patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        return modelMapper.map(patient, PatientDto.class);
    }
}