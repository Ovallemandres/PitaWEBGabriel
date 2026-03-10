-- Pita Logística: tabla de cotizaciones para Supabase
-- Ejecuta este SQL en: Supabase Dashboard → SQL Editor → New query
--
-- Después de ejecutar:
-- 1. Ve a Project Settings → API
-- 2. Copia "Project URL" → CONFIG.supabaseUrl
-- 3. Copia "anon public" key → CONFIG.supabaseAnonKey

-- 1. Crear la tabla (primera vez)
CREATE TABLE IF NOT EXISTS cotizaciones (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  nombre TEXT NOT NULL,
  correo TEXT NOT NULL,
  whatsapp TEXT,
  origen TEXT,
  tipo_mercancia TEXT,
  peso TEXT,
  volumen TEXT,
  tipo_entrega TEXT,
  estado TEXT,
  ciudad TEXT,
  detalles TEXT
);

-- Migración: si ya tienes la tabla, ejecuta para agregar tipo_entrega, estado, ciudad y quitar destino:
-- ALTER TABLE cotizaciones ADD COLUMN IF NOT EXISTS tipo_entrega TEXT;
-- ALTER TABLE cotizaciones ADD COLUMN IF NOT EXISTS estado TEXT;
-- ALTER TABLE cotizaciones ADD COLUMN IF NOT EXISTS ciudad TEXT;
-- ALTER TABLE cotizaciones DROP COLUMN IF EXISTS destino;

-- Si ya tienes la tabla con peso_volumen, ejecuta esta migración:
-- ALTER TABLE cotizaciones ADD COLUMN IF NOT EXISTS peso TEXT;
-- ALTER TABLE cotizaciones ADD COLUMN IF NOT EXISTS volumen TEXT;
-- ALTER TABLE cotizaciones DROP COLUMN IF EXISTS peso_volumen;

-- 2. Habilitar Row Level Security (RLS)
ALTER TABLE cotizaciones ENABLE ROW LEVEL SECURITY;

-- 3. Permitir INSERT para usuarios anónimos (el formulario público)
CREATE POLICY "Permitir insert público"
  ON cotizaciones
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- 4. Solo usuarios autenticados pueden leer (opcional: ajusta si quieres ver datos desde tu app)
-- Si prefieres ver datos solo desde el Dashboard, no crees policy de SELECT y usa el Dashboard.
-- Para permitir lectura solo a usuarios autenticados:
CREATE POLICY "Solo autenticados pueden leer"
  ON cotizaciones
  FOR SELECT
  TO authenticated
  USING (true);

-- 5. Índice para ordenar por fecha
CREATE INDEX IF NOT EXISTS idx_cotizaciones_created_at ON cotizaciones (created_at DESC);
