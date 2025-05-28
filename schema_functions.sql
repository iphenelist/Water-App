-- Function to check if a table exists
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

-- Function to get columns of a table
CREATE OR REPLACE FUNCTION get_table_columns(table_name text)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  columns_json json;
BEGIN
  SELECT json_agg(row_to_json(col_info))
  FROM (
    SELECT column_name, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = $1
    ORDER BY ordinal_position
  ) col_info INTO columns_json;
  
  RETURN columns_json;
END;
$$;
