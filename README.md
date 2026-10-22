# Alcanza

Aplicación de planificación de caja para trabajadores independientes que cobran en fechas e importes variables. Trabajo práctico del Grupo 4, Módulo 2 · Agilidad con IA, Desafío 01.

La app es una sola página: `app/index.html`.

## Datos

- Sin configurar, los datos se guardan en el navegador de cada persona.
- Con Supabase, cada persona entra con mail y contraseña y ve solo sus movimientos. Ejecutar en el SQL Editor del proyecto, en orden, `supabase/schema.sql` y `supabase/02_login.sql`; apagar "Confirm email" en Authentication → Sign In / Providers → Email; y completar `app/config.js` con la URL y la clave pública.

## Publicación en Netlify

- Directorio a publicar: `app`
- Comando de build: ninguno
