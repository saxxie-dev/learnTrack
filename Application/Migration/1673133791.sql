CREATE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;$$ language PLPGSQL;
CREATE TABLE tracks (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    owner_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    completion INT[] DEFAULT '{}' NOT NULL,
    size INT NOT NULL,
    paused BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX tracks_owner_id_index ON tracks (owner_id);
CREATE INDEX tracks_created_at_index ON tracks (created_at);
CREATE TRIGGER update_tracks_updated_at BEFORE UPDATE ON tracks FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();
ALTER TABLE tracks ADD CONSTRAINT tracks_ref_owner_id FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE NO ACTION;
