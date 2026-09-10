CREATE TABLE IF NOT EXISTS taxi_trips(
 id BIGSERIAL PRIMARY KEY,
 pickup_ts TIMESTAMP NOT NULL,
 dropoff_ts TIMESTAMP NOT NULL,
 passenger_count INT NOT NULL,
 trip_distance NUMERIC(8,2) NOT NULL,
 fare_amount NUMERIC(10,2) NOT NULL,
 tip_amount NUMERIC(10,2) NOT NULL,
 total_amount NUMERIC(10,2) NOT NULL,
 payment_type VARCHAR(30) NOT NULL,
 pickup_zone INT NOT NULL,
 dropoff_zone INT NOT NULL
);
INSERT INTO taxi_trips
SELECT g,
 TIMESTAMP '2024-01-01' + ((g % 525600)*INTERVAL '1 minute'),
 TIMESTAMP '2024-01-01' + ((g % 525600)*INTERVAL '1 minute') + ((5+(g%50))*INTERVAL '1 minute'),
 1+(g%5), ROUND((1+(g%400)/10.0)::numeric,2),
 ROUND((5+(g%800)/10.0)::numeric,2), ROUND(((g%300)/10.0)::numeric,2),
 ROUND((8+(g%1000)/10.0)::numeric,2),
 CASE WHEN g%3=0 THEN 'Card' ELSE 'Cash' END, 1+(g%260), 1+(g%260)
FROM generate_series(1,1200000) g ON CONFLICT DO NOTHING;
CREATE INDEX IF NOT EXISTS idx_taxi_pickup ON taxi_trips(pickup_ts);
CREATE INDEX IF NOT EXISTS idx_taxi_zones ON taxi_trips(pickup_zone,dropoff_zone);
CREATE MATERIALIZED VIEW IF NOT EXISTS daily_fare_summary AS
SELECT date_trunc('day',pickup_ts) day, count(*) trips, avg(fare_amount) avg_fare,
       sum(total_amount) revenue
FROM taxi_trips GROUP BY 1;
