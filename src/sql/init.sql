CREATE TABLE IF NOT EXISTS ans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS components (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type_id INTEGER NOT NULL,
            value TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 0,
            footprint TEXT NOT NULL,
            vendor_id INTEGER NOT NULL,
            description TEXT NOT NULL,
            vendor_part_number TEXT NOT NULL,
            price INTEGER NOT NULL DEFAULT 0
);

-- /// Using the `Table` derive macro to generate the `Components` table
-- #[derive(Table, Default, serde::Serialize, serde::Deserialize)]
-- pub struct Components {
--     #[geekorm(primary_key, auto_increment)]
--     id: PrimaryKeyInteger,
--     type_id: i32,
--     value: String,
--     quantity: u64,
--     footprint: String,
--     vendor_id: i32, // manual foreign key cos not supported by geekorm
--     description: String,
--     vendor_part_number: String,
--     price: i32,
-- }

CREATE TABLE IF NOT EXISTS vendors (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT NOT NULL,
            description TEXT NOT NULL,
            name TEXT NOT NULL, // indexed cos always queried by name
);

-- /// Using the `Table` derive macro to generate the `Components` table
-- #[derive(Table, Default, serde::Serialize, serde::Deserialize)]
-- pub struct Vendors {
--     #[geekorm(primary_key, auto_increment)]
--     id: PrimaryKeyInteger,
--     url: String,
--     description: String,
--     name: String, // indexed cos always queried by name
-- }

CREATE TABLE IF NOT EXISTS types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, -- indexed cos always queried by name
            description TEXT NOT NULL,
);
CREATE INDEX typ_name_idx ON types (name);

-- /// Using the `Table` derive macro to generate the `Components` table
-- #[derive(Table, Default, serde::Serialize, serde::Deserialize)]
-- pub struct Types {
--     #[geekorm(primary_key, auto_increment)]
--     id: PrimaryKeyInteger,
--     name: String, // indexed cos always queried by name
--     description: String,
-- }

-- CREATE TABLE IF NOT EXISTS users (
--             id INTEGER PRIMARY KEY AUTOINCREMENT,
--             username TEXT NOT NULL,
--             password TEXT NOT NULL,
--             status INTEGER NOT NULL DEFAULT 0
-- );

-- #[derive(Table, Default, serde::Serialize, serde::Deserialize)]
-- pub struct Users {
--     #[geekorm(primary_key, auto_increment)]
--     id: PrimaryKeyInteger,
--     /// Unique username field
--     #[geekorm(unique)]
--     username: String,
--     /// Password field with automatic hashing
--     #[geekorm(hash)]
--     password: String,
--     // Status to handle permission level
--     status: i32,
-- }
