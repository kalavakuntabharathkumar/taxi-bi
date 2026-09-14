package com.example.taxibi;
import org.springframework.jdbc.core.JdbcTemplate; import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/reports")
public class ReportController {
 private final JdbcTemplate db; public ReportController(JdbcTemplate db){this.db=db;}
 @GetMapping("/daily") public List<Map<String,Object>> daily(){return db.queryForList("select * from daily_fare_summary order by day");}
 @GetMapping("/zones") public List<Map<String,Object>> zones(){return db.queryForList("select pickup_zone, count(*) trips, round(avg(total_amount),2) avg_total from taxi_trips group by pickup_zone order by trips desc limit 20");}
 @PostMapping("/refresh") public Map<String,String> refresh(){db.execute("refresh materialized view daily_fare_summary"); return Map.of("status","refreshed");}
}
