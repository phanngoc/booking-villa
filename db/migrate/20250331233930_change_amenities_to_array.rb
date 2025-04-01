class ChangeAmenitiesToArray < ActiveRecord::Migration[7.2]
  def up
    # Chuyển đổi dữ liệu text thành jsonb array
    execute <<-SQL
      ALTER TABLE villas 
      ALTER COLUMN amenities TYPE jsonb 
      USING CASE 
        WHEN amenities IS NULL THEN '[]'::jsonb
        ELSE jsonb_build_array(amenities)
      END
    SQL
  end

  def down
    # Chuyển đổi ngược lại từ jsonb sang text
    execute <<-SQL
      ALTER TABLE villas 
      ALTER COLUMN amenities TYPE text 
      USING CASE 
        WHEN amenities IS NULL THEN ''
        ELSE (amenities->0)::text
      END
    SQL
  end
end
