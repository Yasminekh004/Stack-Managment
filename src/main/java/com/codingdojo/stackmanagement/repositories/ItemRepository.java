package com.codingdojo.stackmanagement.repositories;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.codingdojo.stackmanagement.models.Item;
import com.codingdojo.stackmanagement.models.User;


@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {

	Page<Item> findByUser(Pageable pageable, User user);
	
	@Query(value = "SELECT * FROM items WHERE LOWER(name) LIKE LOWER(CONCAT('%', :keyword, '%'))", countQuery = "SELECT count(*) FROM chores WHERE LOWER(name) LIKE LOWER(CONCAT('%', :keyword, '%'))", nativeQuery = true)
	Page<Item> searchAvailableItems(@Param("keyword") String keyword, Pageable pageable);
	
	Page<Item> findByCategoryAndUser(Pageable pageable, String category, User user);
	
	@Query("SELECT DISTINCT i.category FROM Item i")
	List<String> findDistinctCategories();
}
