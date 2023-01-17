ALTER TABLE tracks DROP COLUMN completion;
ALTER TABLE tracks ADD COLUMN completion2 BOOLEAN[] DEFAULT '{}' NOT NULL;
CREATE OR REPLACE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;$$ language PLPGSQL;
