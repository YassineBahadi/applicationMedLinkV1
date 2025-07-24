package com.nichanlabs.medlink.controller;

import com.nichanlabs.medlink.dto.JwtAuthenticationResponse;
import com.nichanlabs.medlink.dto.LoginRequest;
import com.nichanlabs.medlink.dto.SignUpRequest;
import com.nichanlabs.medlink.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        JwtAuthenticationResponse response = authService.authenticateUser(loginRequest);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignUpRequest signUpRequest) {
        Long userId = authService.registerUser(signUpRequest);
        return ResponseEntity.ok("User registered successfully with id: " + userId);
    }
}