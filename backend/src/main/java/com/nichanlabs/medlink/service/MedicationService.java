package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.MedicationDto;
import com.nichanlabs.medlink.exception.ResourceNotFoundException;
import com.nichanlabs.medlink.model.Medication;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.MedicationRepository;
import com.nichanlabs.medlink.repository.PatientRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MedicationService {

    @Autowired
    private MedicationRepository medicationRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ModelMapper modelMapper;

    public List<MedicationDto> getAllMedicationsByPatientId(Long patientId) {
        List<Medication> medications = medicationRepository.findByPatientId(patientId);
        return medications.stream()
                .map(medication -> modelMapper.map(medication, MedicationDto.class))
                .collect(Collectors.toList());
    }

    public MedicationDto createMedication(Long patientId, MedicationDto medicationDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Medication medication = modelMapper.map(medicationDto, Medication.class);
        medication.setPatient(patient);

        Medication savedMedication = medicationRepository.save(medication);
        return modelMapper.map(savedMedication, MedicationDto.class);
    }

    public MedicationDto updateMedication(Long patientId, Long medicationId, MedicationDto medicationDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Medication medication = medicationRepository.findById(medicationId)
                .orElseThrow(() -> new ResourceNotFoundException("Medication", "id", medicationId));

        if(!medication.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("Medication", "id", medicationId);
        }

        medication.setName(medicationDto.getName());
        medication.setDosage(medicationDto.getDosage());
        medication.setForm(medicationDto.getForm());
        medication.setTimesPerDay(medicationDto.getTimesPerDay());
        medication.setIntakeTimes(medicationDto.getIntakeTimes());

        Medication updatedMedication = medicationRepository.save(medication);
        return modelMapper.map(updatedMedication, MedicationDto.class);
    }

    public void deleteMedication(Long patientId, Long medicationId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Medication medication = medicationRepository.findById(medicationId)
                .orElseThrow(() -> new ResourceNotFoundException("Medication", "id", medicationId));

        if(!medication.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("Medication", "id", medicationId);
        }

        medicationRepository.delete(medication);
    }
}