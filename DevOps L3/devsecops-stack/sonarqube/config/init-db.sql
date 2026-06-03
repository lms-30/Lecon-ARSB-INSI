-- ============================================================
--  SONARQUBE - INITIALISATION BASE DE DONNÉES PostgreSQL
-- ============================================================

-- Extensions utiles
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Schéma SonarQube (créé automatiquement par SQ, mais on prépare les permissions)
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
GRANT ALL PRIVILEGES ON SCHEMA public TO sonar;
