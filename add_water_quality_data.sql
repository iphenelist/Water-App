-- Script to create water_quality table and add sample data
-- Run this in Supabase SQL Editor

-- Create water_quality table for area-based water data
CREATE TABLE IF NOT EXISTS water_quality (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  area TEXT NOT NULL,
  amount DECIMAL NOT NULL DEFAULT 0.0,
  ph DECIMAL NOT NULL DEFAULT 7.0,
  turbidity DECIMAL NOT NULL DEFAULT 1.0,
  contamination_level DECIMAL NOT NULL DEFAULT 0.1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add sample water quality data for different areas
INSERT INTO water_quality (area, amount, ph, turbidity, contamination_level) VALUES
('Kariakoo', 850.0, 7.2, 0.8, 0.15),
('Mabibo', 1200.0, 6.9, 1.2, 0.25),
('Mnazi', 650.0, 7.5, 0.5, 0.08),
('Kinondoni', 950.0, 7.1, 1.0, 0.18),
('Temeke', 750.0, 6.8, 1.5, 0.32),
('Ilala', 1100.0, 7.3, 0.7, 0.12),
('Ubungo', 800.0, 7.0, 0.9, 0.20),
('Kigamboni', 600.0, 6.7, 2.1, 0.45);

-- Add comment to document the table
COMMENT ON TABLE water_quality IS 'Water quality and quantity data by area for customer dashboard';
COMMENT ON COLUMN water_quality.area IS 'Name of the area/location';
COMMENT ON COLUMN water_quality.amount IS 'Water quantity available in liters';
COMMENT ON COLUMN water_quality.ph IS 'pH level of water (6.5-8.5 is normal)';
COMMENT ON COLUMN water_quality.turbidity IS 'Turbidity level in NTU (lower is better)';
COMMENT ON COLUMN water_quality.contamination_level IS 'Contamination level as decimal (0.0-1.0, lower is better)';
