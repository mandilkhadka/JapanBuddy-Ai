class EnablePgvectorExtension < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    begin
      execute "CREATE EXTENSION IF NOT EXISTS vector"
    rescue ActiveRecord::StatementInvalid => e
      puts "WARNING: Could not create vector extension: #{e.message}"
      puts "Vector search will be disabled. To enable, install pgvector matching your PostgreSQL version."
    end
  end

  def down
    begin
      execute "DROP EXTENSION IF EXISTS vector"
    rescue ActiveRecord::StatementInvalid
      # Ignore
    end
  end
end
