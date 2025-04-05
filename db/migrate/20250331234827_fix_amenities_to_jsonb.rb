class FixAmenitiesToJsonb < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      ALTER TABLE villas 
      ALTER COLUMN amenities TYPE jsonb 
      USING CASE 
        WHEN amenities IS NULL THEN '[]'::jsonb
        ELSE to_jsonb(amenities)
      END
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE villas 
      ALTER COLUMN amenities TYPE varchar[] 
      USING CASE 
        WHEN amenities IS NULL THEN '{}'::varchar[]
        ELSE ARRAY[amenities::text]
      END
    SQL
  end
end
