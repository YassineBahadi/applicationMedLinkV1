package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.MedicalTestDto;
import com.nichanlabs.medlink.exception.ResourceNotFoundException;
import com.nichanlabs.medlink.model.MedicalTest;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.MedicalTestRepository;
import com.nichanlabs.medlink.repository.PatientRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MedicalTestService {

    @Autowired
    private MedicalTestRepository medicalTestRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ModelMapper modelMapper;

    public List<MedicalTestDto> getAllMedicalTestsByPatientId(Long patientId) {
        List<MedicalTest> medicalTests = medicalTestRepository.findByPatientId(patientId);
        return medicalTests.stream()
                .map(test -> modelMapper.map(test, MedicalTestDto.class))
                .collect(Collectors.toList());
    }

    public List<MedicalTestDto> getMedicalTestsByType(Long patientId, String testType) {
        List<MedicalTest> medicalTests = medicalTestRepository.findByPatientIdAndTestType(patientId, testType);
        return medicalTests.stream()
                .map(test -> modelMapper.map(test, MedicalTestDto.class))
                .collect(Collectors.toList());
    }

    public MedicalTestDto createMedicalTest(Long patientId, MedicalTestDto medicalTestDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        MedicalTest medicalTest = modelMapper.map(medicalTestDto, MedicalTest.class);
        medicalTest.setPatient(patient);

        MedicalTest savedTest = medicalTestRepository.save(medicalTest);
        return modelMapper.map(savedTest, MedicalTestDto.class);
    }

    public MedicalTestDto updateMedicalTest(Long patientId, Long testId, MedicalTestDto medicalTestDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        MedicalTest medicalTest = medicalTestRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("MedicalTest", "id", testId));

        if(!medicalTest.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("MedicalTest", "id", testId);
        }

        medicalTest.setTestType(medicalTestDto.getTestType());
        medicalTest.setTestName(medicalTestDto.getTestName());
        medicalTest.setResult(medicalTestDto.getResult());
        medicalTest.setFilePath(medicalTestDto.getFilePath());
        medicalTest.setTestDate(medicalTestDto.getTestDate());

        MedicalTest updatedTest = medicalTestRepository.save(medicalTest);
        return modelMapper.map(updatedTest, MedicalTestDto.class);
    }

    public void deleteMedicalTest(Long patientId, Long testId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        MedicalTest medicalTest = medicalTestRepository.findById(testId)
                .orElseThrow(() -> new ResourceNotFoundException("MedicalTest", "id", testId));

        if(!medicalTest.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("MedicalTest", "id", testId);
        }

        medicalTestRepository.delete(medicalTest);
    }
}