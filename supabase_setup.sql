-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create function to check if a table exists
CREATE OR REPLACE FUNCTION check_table_exists(table_name text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  table_exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_name = $1
  ) INTO table_exists;

  RETURN table_exists;
END;
$$;

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  user_type TEXT NOT NULL CHECK (user_type IN ('customer', 'researcher')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create customer_data table
CREATE TABLE IF NOT EXISTS customer_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id),
  location TEXT NOT NULL,
  water_quantity DECIMAL NOT NULL DEFAULT 500.0,
  water_flow_enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create water_quality table
CREATE TABLE IF NOT EXISTS water_quality (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customer_data(id),
  ph DECIMAL NOT NULL DEFAULT 7.0,
  turbidity DECIMAL NOT NULL DEFAULT 1.0,
  contamination_level DECIMAL NOT NULL DEFAULT 0.1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create researcher_data table
CREATE TABLE IF NOT EXISTS researcher_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id),
  area TEXT NOT NULL,
  current_rainfall DECIMAL NOT NULL DEFAULT 0.0,
  temperature DECIMAL DEFAULT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

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

-- Create rainfall_data table
CREATE TABLE IF NOT EXISTS rainfall_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  area_id UUID NOT NULL REFERENCES researcher_data(id),
  date DATE NOT NULL,
  amount DECIMAL NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE water_quality ENABLE ROW LEVEL SECURITY;
ALTER TABLE researcher_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE rainfall_data ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles table
CREATE POLICY "Users can view their own profile"
ON profiles FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
ON profiles FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = id);

-- Create policies for customer_data table
CREATE POLICY "Users can view their own customer data"
ON customer_data FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own customer data"
ON customer_data FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own customer data"
ON customer_data FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policies for water_quality table
CREATE POLICY "Users can view water quality data for their customer data"
ON water_quality FOR SELECT
USING (EXISTS (
  SELECT 1 FROM customer_data
  WHERE customer_data.id = water_quality.customer_id
  AND customer_data.user_id = auth.uid()
));

CREATE POLICY "Users can update water quality data for their customer data"
ON water_quality FOR UPDATE
USING (EXISTS (
  SELECT 1 FROM customer_data
  WHERE customer_data.id = water_quality.customer_id
  AND customer_data.user_id = auth.uid()
));

CREATE POLICY "Users can insert water quality data for their customer data"
ON water_quality FOR INSERT
WITH CHECK (EXISTS (
  SELECT 1 FROM customer_data
  WHERE customer_data.id = water_quality.customer_id
  AND customer_data.user_id = auth.uid()
));

-- Create policies for researcher_data table
CREATE POLICY "Users can view their own researcher data"
ON researcher_data FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own researcher data"
ON researcher_data FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own researcher data"
ON researcher_data FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policies for rainfall_data table
CREATE POLICY "Users can view rainfall data for their research area"
ON rainfall_data FOR SELECT
USING (EXISTS (
  SELECT 1 FROM researcher_data
  WHERE researcher_data.id = rainfall_data.area_id
  AND researcher_data.user_id = auth.uid()
));

CREATE POLICY "Users can update rainfall data for their research area"
ON rainfall_data FOR UPDATE
USING (EXISTS (
  SELECT 1 FROM researcher_data
  WHERE researcher_data.id = rainfall_data.area_id
  AND researcher_data.user_id = auth.uid()
));

CREATE POLICY "Users can insert rainfall data for their research area"
ON rainfall_data FOR INSERT
WITH CHECK (EXISTS (
  SELECT 1 FROM researcher_data
  WHERE researcher_data.id = rainfall_data.area_id
  AND researcher_data.user_id = auth.uid()
));
