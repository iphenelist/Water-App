-- Test script to check and create water_quality table with sample data
-- Run this in Supabase SQL Editor

-- First, check if the table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'water_quality';

-- Create the table if it doesn't exist (with the exact columns you mentioned)
CREATE TABLE IF NOT EXISTS water_quality (
  id SERIAL PRIMARY KEY,
  area TEXT NOT NULL,
  amount DECIMAL NOT NULL DEFAULT 0.0,
  ph DECIMAL NOT NULL DEFAULT 7.0,
  turbidity DECIMAL NOT NULL DEFAULT 1.0,
  contamination_level DECIMAL NOT NULL DEFAULT 0.1
);

-- Clear any existing data and insert fresh sample data
DELETE FROM water_quality;

-- Insert sample data for different areas
INSERT INTO water_quality (area, amount, ph, turbidity, contamination_level) VALUES
('Kariakoo', 850.0, 7.2, 0.8, 0.15),
('Mabibo', 1200.0, 6.9, 1.2, 0.25),
('Mnazi', 650.0, 7.5, 0.5, 0.08),
('Kinondoni', 950.0, 7.1, 1.0, 0.18),
('Temeke', 750.0, 6.8, 1.5, 0.32),
('Ilala', 1100.0, 7.3, 0.7, 0.12),
('Ubungo', 800.0, 7.0, 0.9, 0.20),
('Kigamboni', 600.0, 6.7, 2.1, 0.45);

-- Verify the data was inserted
SELECT * FROM water_quality ORDER BY area;
