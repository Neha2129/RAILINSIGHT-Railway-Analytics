USE railone_analytics;

-- 1. Total Tickets
SELECT COUNT(*) AS total_tickets
FROM tickets;

-- 2. Total Users
SELECT COUNT(*) AS total_users
FROM users;

-- 3. Total Revenue
SELECT ROUND(SUM(fare_amount), 2) AS total_revenue
FROM tickets
WHERE payment_status = 'Success';

-- 4. Average Fare
SELECT ROUND(AVG(fare_amount), 2) AS average_fare
FROM tickets
WHERE payment_status = 'Success';

-- 5. Reserved vs Unreserved
SELECT
    ticket_type,
    COUNT(*) AS total_tickets,
    ROUND(SUM(fare_amount), 2) AS total_revenue,
    ROUND(AVG(fare_amount), 2) AS average_fare
FROM tickets
WHERE payment_status = 'Success'
GROUP BY ticket_type
ORDER BY total_tickets DESC;

-- 6. Tickets by Railway Line
SELECT
    railway_line,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY railway_line
ORDER BY total_tickets DESC;

-- 7. Revenue by Railway Line
SELECT
    railway_line,
    ROUND(SUM(fare_amount), 2) AS total_revenue
FROM tickets
WHERE payment_status = 'Success'
GROUP BY railway_line
ORDER BY total_revenue DESC;

-- 8. Reserved vs Unreserved by Railway Line
SELECT
    railway_line,
    ticket_type,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY railway_line, ticket_type
ORDER BY railway_line, total_tickets DESC;

-- 9. Peak Booking Hours
SELECT
    HOUR(booking_datetime) AS booking_hour,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY HOUR(booking_datetime)
ORDER BY total_tickets DESC;

-- 10. Top 10 Source Stations
SELECT
    s.station_name,
    COUNT(*) AS total_tickets
FROM tickets t
JOIN stations s
    ON t.source_station_id = s.station_id
GROUP BY s.station_name
ORDER BY total_tickets DESC
LIMIT 10;

-- 11. Top 10 Popular Routes
SELECT
    ss.station_name AS source_station,
    ds.station_name AS destination_station,
    COUNT(*) AS total_tickets
FROM tickets t
JOIN stations ss
    ON t.source_station_id = ss.station_id
JOIN stations ds
    ON t.destination_station_id = ds.station_id
GROUP BY ss.station_name, ds.station_name
ORDER BY total_tickets DESC
LIMIT 10;

-- 12. Ticket Cancellation Analysis
SELECT
    cancellation_status,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY cancellation_status
ORDER BY total_tickets DESC;

-- 13. Payment Status Analysis
SELECT
    payment_status,
    COUNT(*) AS total_transactions,
    ROUND(SUM(fare_amount), 2) AS total_amount
FROM tickets
GROUP BY payment_status
ORDER BY total_transactions DESC;

-- 14. Payment Method Analysis
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    ROUND(SUM(fare_amount), 2) AS total_amount
FROM tickets
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 15. User Type Analysis
SELECT
    u.user_type,
    COUNT(t.ticket_id) AS total_tickets,
    ROUND(SUM(t.fare_amount), 2) AS total_revenue
FROM users u
JOIN tickets t
    ON u.user_id = t.user_id
GROUP BY u.user_type
ORDER BY total_tickets DESC;

-- 16. Average Train Delay
SELECT
    ROUND(AVG(delay_minutes), 2) AS average_delay_minutes
FROM train_status;

-- 17. Delayed Trains
SELECT
    COUNT(DISTINCT train_id) AS delayed_trains
FROM train_status
WHERE status = 'Delayed';

-- 18. Train Status Distribution
SELECT
    status,
    COUNT(*) AS status_count
FROM train_status
GROUP BY status
ORDER BY status_count DESC;

-- 19. Train Status by Railway Line
SELECT
    tr.railway_line,
    ts.status,
    COUNT(*) AS status_count
FROM train_status ts
JOIN trains tr
    ON ts.train_id = tr.train_id
GROUP BY tr.railway_line, ts.status
ORDER BY tr.railway_line, status_count DESC;
