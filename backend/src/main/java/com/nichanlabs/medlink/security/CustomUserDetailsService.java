package com.nichanlabs.medlink.security;

import com.nichanlabs.medlink.model.Patient;
import com.nichanlabs.medlink.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private PatientRepository patientRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Patient patient = patientRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username : " + username));

        return UserPrincipal.create(patient);
    }

    @Transactional
    public UserDetails loadUserById(Long id) {
        Patient patient = patientRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with id : " + id));

        return UserPrincipal.create(patient);
    }
}