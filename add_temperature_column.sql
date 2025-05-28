-- Migration script to add temperature column to researcher_data table
-- Run this in Supabase SQL Editor to add temperature support

-- Add temperature column to researcher_data table
ALTER TABLE researcher_data 
ADD COLUMN IF NOT EXISTS temperature DECIMAL DEFAULT NULL;

-- Add comment to document the column
COMMENT ON COLUMN researcher_data.temperature IS 'Temperature in Celsius for weather data';

-- Update existing records with sample temperature data (optional)
-- This is just for testing - you can remove this if you don't want sample data
UPDATE researcher_data 
SET temperature = 25.0 + (RANDOM() * 10) -- Random temperature between 25-35°C
WHERE temperature IS NULL;
