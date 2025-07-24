package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.AppointmentDto;
import com.nichanlabs.medlink.security.CurrentUser;
import com.nichanlabs.medlink.security.UserPrincipal;
import com.nichanlabs.medlink.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping
    @PreAuthorize("hasRole('USER')")
    public List<AppointmentDto> getAllAppointmentsByPatientId(@CurrentUser UserPrincipal currentUser) {
        return appointmentService.getAllAppointmentsByPatientId(currentUser.getId());
    }

    @GetMapping("/upcoming")
    @PreAuthorize("hasRole('USER')")
    public List<AppointmentDto> getUpcomingAppointments(@CurrentUser UserPrincipal currentUser) {
        return appointmentService.getUpcomingAppointments(currentUser.getId());
    }

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public AppointmentDto createAppointment(@CurrentUser UserPrincipal currentUser,
                                            @Valid @RequestBody AppointmentDto appointmentDto) {
        return appointmentService.createAppointment(currentUser.getId(), appointmentDto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public AppointmentDto updateAppointment(@CurrentUser UserPrincipal currentUser,
                                            @PathVariable(value = "id") Long appointmentId,
                                            @Valid @RequestBody AppointmentDto appointmentDto) {
        return appointmentService.updateAppointment(currentUser.getId(), appointmentId, appointmentDto);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> deleteAppointment(@CurrentUser UserPrincipal currentUser,
                                               @PathVariable(value = "id") Long appointmentId) {
        appointmentService.deleteAppointment(currentUser.getId(), appointmentId);
        return ResponseEntity.ok().build();
    }
}