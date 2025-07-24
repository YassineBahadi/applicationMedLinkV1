package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.ClinicalDataDto;
import com.nichanlabs.medlink.exception.ResourceNotFoundException;
import com.nichanlabs.medlink.model.ClinicalData;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.ClinicalDataRepository;
import com.nichanlabs.medlink.repository.PatientRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClinicalDataService {

    @Autowired
    private ClinicalDataRepository clinicalDataRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ModelMapper modelMapper;

    public List<ClinicalDataDto> getAllClinicalDataByPatientId(Long patientId) {
        List<ClinicalData> clinicalData = clinicalDataRepository.findByPatientId(patientId);
        return clinicalData.stream()
                .map(data -> modelMapper.map(data, ClinicalDataDto.class))
                .collect(Collectors.toList());
    }

    public List<ClinicalDataDto> getClinicalDataByType(Long patientId, String parameterType) {
        List<ClinicalData> clinicalData = clinicalDataRepository.findByPatientIdAndParameterType(patientId, parameterType);
        return clinicalData.stream()
                .map(data -> modelMapper.map(data, ClinicalDataDto.class))
                .collect(Collectors.toList());
    }

    public ClinicalDataDto createClinicalData(Long patientId, ClinicalDataDto clinicalDataDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        ClinicalData clinicalData = modelMapper.map(clinicalDataDto, ClinicalData.class);
        clinicalData.setPatient(patient);

        ClinicalData savedData = clinicalDataRepository.save(clinicalData);
        return modelMapper.map(savedData, ClinicalDataDto.class);
    }

    public ClinicalDataDto updateClinicalData(Long patientId, Long dataId, ClinicalDataDto clinicalDataDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        ClinicalData clinicalData = clinicalDataRepository.findById(dataId)
                .orElseThrow(() -> new ResourceNotFoundException("ClinicalData", "id", dataId));

        if(!clinicalData.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("ClinicalData", "id", dataId);
        }

        clinicalData.setParameterType(clinicalDataDto.getParameterType());
        clinicalData.setValue(clinicalDataDto.getValue());
        clinicalData.setRecordedAt(clinicalDataDto.getRecordedAt());

        ClinicalData updatedData = clinicalDataRepository.save(clinicalData);
        return modelMapper.map(updatedData, ClinicalDataDto.class);
    }

    public void deleteClinicalData(Long patientId, Long dataId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        ClinicalData clinicalData = clinicalDataRepository.findById(dataId)
                .orElseThrow(() -> new ResourceNotFoundException("ClinicalData", "id", dataId));

        if(!clinicalData.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("ClinicalData", "id", dataId);
        }

        clinicalDataRepository.delete(clinicalData);
    }
}