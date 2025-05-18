package com.codingdojo.stackmanagement.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.codingdojo.stackmanagement.models.ItemHistory;

public interface ItemHistoryRepository extends JpaRepository<ItemHistory, Long>{
	
	@Query("SELECT h.category, SUM(h.price) FROM ItemHistory h WHERE h.user.id = :userId AND h.action != 'DELETED' GROUP BY h.category")
	List<Object[]> sumPriceByCategoryForUser(@Param("userId") Long userId);

}
