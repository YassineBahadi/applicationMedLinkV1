package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.AppointmentDto;
import com.nichanlabs.medlink.exception.ResourceNotFoundException;
import com.nichanlabs.medlink.model.Appointment;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.AppointmentRepository;
import com.nichanlabs.medlink.repository.PatientRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ModelMapper modelMapper;

    public List<AppointmentDto> getAllAppointmentsByPatientId(Long patientId) {
        List<Appointment> appointments = appointmentRepository.findByPatientId(patientId);
        return appointments.stream()
                .map(appointment -> modelMapper.map(appointment, AppointmentDto.class))
                .collect(Collectors.toList());
    }

    public List<AppointmentDto> getUpcomingAppointments(Long patientId) {
        List<Appointment> appointments = appointmentRepository.findByPatientIdAndAppointmentDateAfter(patientId, LocalDateTime.now());
        return appointments.stream()
                .map(appointment -> modelMapper.map(appointment, AppointmentDto.class))
                .collect(Collectors.toList());
    }

    public AppointmentDto createAppointment(Long patientId, AppointmentDto appointmentDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Appointment appointment = modelMapper.map(appointmentDto, Appointment.class);
        appointment.setPatient(patient);

        Appointment savedAppointment = appointmentRepository.save(appointment);
        return modelMapper.map(savedAppointment, AppointmentDto.class);
    }

    public AppointmentDto updateAppointment(Long patientId, Long appointmentId, AppointmentDto appointmentDto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Appointment", "id", appointmentId));

        if(!appointment.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("Appointment", "id", appointmentId);
        }

        appointment.setTitle(appointmentDto.getTitle());
        appointment.setDescription(appointmentDto.getDescription());
        appointment.setAppointmentDate(appointmentDto.getAppointmentDate());
        appointment.setReminderSet(appointmentDto.isReminderSet());

        Appointment updatedAppointment = appointmentRepository.save(appointment);
        return modelMapper.map(updatedAppointment, AppointmentDto.class);
    }

    public void deleteAppointment(Long patientId, Long appointmentId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient", "id", patientId));

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new ResourceNotFoundException("Appointment", "id", appointmentId));

        if(!appointment.getPatient().getId().equals(patient.getId())) {
            throw new ResourceNotFoundException("Appointment", "id", appointmentId);
        }

        appointmentRepository.delete(appointment);
    }
}