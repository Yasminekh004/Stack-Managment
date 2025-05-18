package com.codingdojo.stackmanagement.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.codingdojo.stackmanagement.models.User;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {
	List<User> findAll();
	Optional<User> findByEmail(String email);
 
}//end repository 
