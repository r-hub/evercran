
CREATE TABLE packages (
   package TEXT,
   version TEXT,
   depends TEXT,
   suggests TEXT,
   imports TEXT,
   linkingto TEXT,
   enhances TEXT,
   license TEXT,
   md5sum  CHAR(32),
   needscompilation  BOOLEAN,
   license_is_foss BOOLEAN,
   license_restricts_use BOOLEAN,
   os_type TEXT,
   priority TEXT,
   archs TEXT,
   path TEXT,
   systemrequirements TEXT,
   release_date TIMESTAMP,
   current BOOLEAN);

CREATE INDEX idx_packages_package_date ON packages(package, release_date);
CREATE INDEX idx_packages_package ON packages(package);
CREATE INDEX idx_packages_date ON packages(release_date);

CREATE TABLE ids (
   package TEXT,
   id TEXT
);

CREATE INDEX idx_ids_package ON ids(package);
