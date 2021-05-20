package edu.spingsecurity.repository;

import edu.spingsecurity.model.Company;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CompanyRepository extends JpaRepository<Company, Long> {
}
