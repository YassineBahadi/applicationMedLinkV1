package com.nichanlabs.medlink.service;

import com.nichanlabs.medlink.dto.JwtAuthenticationResponse;
import com.nichanlabs.medlink.dto.LoginRequest;
import com.nichanlabs.medlink.dto.SignUpRequest;
import com.nichanlabs.medlink.exception.AppException;
import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.PatientRepository;
import com.nichanlabs.medlink.security.JwtTokenProvider;
import com.nichanlabs.medlink.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    public JwtAuthenticationResponse authenticateUser(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String jwt = tokenProvider.generateToken(authentication);
        return new JwtAuthenticationResponse(jwt);
    }

    public Long registerUser(SignUpRequest signUpRequest) {
        if(patientRepository.existsByUsername(signUpRequest.getUsername())) {
            throw new AppException("Username is already taken!");
        }

        Patient patient = new Patient();
        patient.setUsername(signUpRequest.getUsername());
        patient.setPassword(passwordEncoder.encode(signUpRequest.getPassword()));
        patient.setFirstName(signUpRequest.getFirstName());
        patient.setLastName(signUpRequest.getLastName());
        patient.setDateOfBirth(signUpRequest.getDateOfBirth());
        patient.setInsuranceNumber(signUpRequest.getInsuranceNumber());
        patient.setComorbidities(signUpRequest.getComorbidities());
        patient.setWeight(signUpRequest.getWeight());
        patient.setHeight(signUpRequest.getHeight());

        return patientRepository.save(patient).getId();
    }
}