-- EXAMPLE ONLY. This shows the format of a migration and is not part of the assignment.
-- It lives in examples/ so it is NOT applied. Only files in migrations/ are applied.
-- Write your own schema in migrations/001_<name>.sql.
 
-- Each file runs inside a transaction, so do not add BEGIN or COMMIT yourself.
 
CREATE TABLE notebooks (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title      TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
 
CREATE TABLE notes (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  notebook_id UUID NOT NULL REFERENCES notebooks(id),
  body        TEXT NOT NULL,
  is_pinned   BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
 
-- A partial unique index lets the database enforce a rule for only some rows.
-- Here: at most one pinned note per notebook.
CREATE UNIQUE INDEX idx_one_pinned_note_per_notebook
  ON notes (notebook_id) WHERE is_pinned = TRUE;
 
CREATE INDEX idx_notes_notebook_id ON notes (notebook_id);
 