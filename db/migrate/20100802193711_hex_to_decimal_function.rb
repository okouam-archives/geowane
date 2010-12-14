class HexToDecimalFunction < ActiveRecord::Migration
  def self.up
    execute %{
      create or replace function to_dec(character varying)
       returns integer as $$
       declare r int;
       begin
         execute E'select x\\''||$1|| E'\\'::integer' into r;
         return r;
       end
       $$ language plpgsql;
    }
  end

  def self.down
  end
end
