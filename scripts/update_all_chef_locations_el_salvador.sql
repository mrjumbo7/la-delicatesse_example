# Manual de Usuario - La Délicatesse
## Plataforma de Chefs a Domicilio

---

## Índice
1. [Introducción](#introducción)
2. [Registro e Inicio de Sesión](#registro-e-inicio-de-sesión)
3. [Navegación Principal](#navegación-principal)
4. [Para Clientes](#para-clientes)
5. [Para Chefs](#para-chefs)
6. [Gestión de Perfil](#gestión-de-perfil)
7. [Sistema de Mensajería](#sistema-de-mensajería)
8. [Configuración de Idioma](#configuración-de-idioma)
9. [Soporte y Contacto](#soporte-y-contacto)
10. [Preguntas Frecuentes](#preguntas-frecuentes)

---

## Introducción

**La Délicatesse** es una plataforma digital que conecta clientes exigentes con chefs certificados para crear experiencias culinarias únicas en la comodidad del hogar. Nuestra plataforma ofrece servicios gastronómicos premium con más de 50 chefs certificados, 1000+ servicios realizados y una calificación promedio de 4.9 estrellas.

### Características Principales:
- 🍽️ **Servicios de Chef a Domicilio**: Contrata chefs profesionales para eventos especiales
- 📚 **Catálogo de Recetas Premium**: Accede a recetas exclusivas de chefs certificados
- 💬 **Sistema de Mensajería**: Comunicación directa con los chefs
- ⭐ **Sistema de Reseñas**: Califica y comenta los servicios recibidos
- 🌍 **Soporte Multiidioma**: Disponible en Español e Inglés

---

## Registro e Inicio de Sesión

### Crear una Cuenta Nueva

1. **Acceder al Registro**:
   - Visita la página principal de La Délicatesse
   - Haz clic en el botón **"Registrarse"** en la esquina superior derecha

2. **Completar el Formulario**:
   - **Nombre completo**: Ingresa tu nombre y apellidos
   - **Correo electrónico**: Usa un email válido y activo
   - **Contraseña**: Mínimo 8 caracteres, incluye mayúsculas, minúsculas y números
   - **Tipo de usuario**: Selecciona "Cliente" o "Chef"
   - **Ubicación**: Selecciona tu departamento y municipio en El Salvador

3. **Verificación**:
   - Revisa tu correo electrónico para confirmar la cuenta
   - Haz clic en el enlace de verificación recibido

### Iniciar Sesión

1. Haz clic en **"Iniciar Sesión"** en la página principal
2. Ingresa tu correo electrónico y contraseña
3. Haz clic en **"Entrar"**

> **💡 Consejo**: Mantén tu sesión activa marcando "Recordarme" para mayor comodidad.

---

## Navegación Principal

### Menú Principal
La barra de navegación incluye:

- **🏠 Inicio**: Página principal con información general
- **👨‍🍳 Chefs**: Catálogo de chefs disponibles
- **📖 Recetas**: Colección de recetas premium
- **🌐 Idioma**: Cambiar entre Español e Inglés
- **👤 Perfil**: Acceso a tu cuenta personal

### Búsqueda y Filtros
- Utiliza la barra de búsqueda para encontrar chefs o recetas específicas
- Aplica filtros por:
  - Especialidad culinaria
  - Ubicación geográfica
  - Rango de precios
  - Calificación
  - Disponibilidad

---

## Para Clientes

### Explorar y-- Script para actualizar TODAS las ubicaciones de chefs con municipios y departamentos de El Salvador
-- Incluye chefs existentes y nuevos

-- Actualizar todos los chefs con ubicaciones de El Salvador
UPDATE perfiles_chef SET ubicacion = 'San Salvador, San Salvador' WHERE usuario_id = 1;
UPDATE perfiles_chef SET ubicacion = 'Santa Ana, Santa Ana' WHERE usuario_id = 2;
UPDATE perfiles_chef SET ubicacion = 'San Miguel, San Miguel' WHERE usuario_id = 3;
UPDATE perfiles_chef SET ubicacion = 'Soyapango, San Salvador' WHERE usuario_id = 4;
UPDATE perfiles_chef SET ubicacion = 'Mejicanos, San Salvador' WHERE usuario_id = 5;
UPDATE perfiles_chef SET ubicacion = 'Santa Tecla, La Libertad' WHERE usuario_id = 6;
UPDATE perfiles_chef SET ubicacion = 'Apopa, San Salvador' WHERE usuario_id = 7;
UPDATE perfiles_chef SET ubicacion = 'Delgado, San Salvador' WHERE usuario_id = 8;
UPDATE perfiles_chef SET ubicacion = 'Ahuachapán, Ahuachapán' WHERE usuario_id = 9;
UPDATE perfiles_chef SET ubicacion = 'Usulután, Usulután' WHERE usuario_id = 10;
UPDATE perfiles_chef SET ubicacion = 'Cojutepeque, Cuscatlán' WHERE usuario_id = 11;
UPDATE perfiles_chef SET ubicacion = 'Zacatecoluca, La Paz' WHERE usuario_id = 12;
UPDATE perfiles_chef SET ubicacion = 'Sensuntepeque, Cabañas' WHERE usuario_id = 13;
UPDATE perfiles_chef SET ubicacion = 'Chalatenango, Chalatenango' WHERE usuario_id = 14;
UPDATE perfiles_chef SET ubicacion = 'La Unión, La Unión' WHERE usuario_id = 15;
UPDATE perfiles_chef SET ubicacion = 'Sonsonate, Sonsonate' WHERE usuario_id = 16;
UPDATE perfiles_chef SET ubicacion = 'San Vicente, San Vicente' WHERE usuario_id = 17;
UPDATE perfiles_chef SET ubicacion = 'San Francisco Gotera, Morazán' WHERE usuario_id = 18;
UPDATE perfiles_chef SET ubicacion = 'Antiguo Cuscatlán, La Libertad' WHERE usuario_id = 19;
UPDATE perfiles_chef SET ubicacion = 'Ilopango, San Salvador' WHERE usuario_id = 20;
UPDATE perfiles_chef SET ubicacion = 'Acajutla, Sonsonate' WHERE usuario_id = 21;
UPDATE perfiles_chef SET ubicacion = 'Colón, La Libertad' WHERE usuario_id = 22;
UPDATE perfiles_chef SET ubicacion = 'Quezaltepeque, La Libertad' WHERE usuario_id = 23;
UPDATE perfiles_chef SET ubicacion = 'Tonacatepeque, San Salvador' WHERE usuario_id = 24;
UPDATE perfiles_chef SET ubicacion = 'Nejapa, San Salvador' WHERE usuario_id = 25;
UPDATE perfiles_chef SET ubicacion = 'Ayutuxtepeque, San Salvador' WHERE usuario_id = 26;
UPDATE perfiles_chef SET ubicacion = 'Cuscatancingo, San Salvador' WHERE usuario_id = 27;
UPDATE perfiles_chef SET ubicacion = 'San Marcos, San Salvador' WHERE usuario_id = 28;
UPDATE perfiles_chef SET ubicacion = 'Santo Tomás, San Salvador' WHERE usuario_id = 29;
UPDATE perfiles_chef SET ubicacion = 'Aguilares, San Salvador' WHERE usuario_id = 30;
UPDATE perfiles_chef SET ubicacion = 'El Paisnal, San Salvador' WHERE usuario_id = 31;
UPDATE perfiles_chef SET ubicacion = 'Guazapa, San Salvador' WHERE usuario_id = 32;
UPDATE perfiles_chef SET ubicacion = 'Opico, La Libertad' WHERE usuario_id = 33;
UPDATE perfiles_chef SET ubicacion = 'Ciudad Arce, La Libertad' WHERE usuario_id = 34;
UPDATE perfiles_chef SET ubicacion = 'Comasagua, La Libertad' WHERE usuario_id = 35;
UPDATE perfiles_chef SET ubicacion = 'Huizúcar, La Libertad' WHERE usuario_id = 36;
UPDATE perfiles_chef SET ubicacion = 'Jayaque, La Libertad' WHERE usuario_id = 37;
UPDATE perfiles_chef SET ubicacion = 'Jicalapa, La Libertad' WHERE usuario_id = 38;
UPDATE perfiles_chef SET ubicacion = 'La Libertad, La Libertad' WHERE usuario_id = 39;
UPDATE perfiles_chef SET ubicacion = 'Nuevo Cuscatlán, La Libertad' WHERE usuario_id = 40;
UPDATE perfiles_chef SET ubicacion = 'San José Villanueva, La Libertad' WHERE usuario_id = 41;
UPDATE perfiles_chef SET ubicacion = 'Talnique, La Libertad' WHERE usuario_id = 42;
UPDATE perfiles_chef SET ubicacion = 'Tamanique, La Libertad' WHERE usuario_id = 43;
UPDATE perfiles_chef SET ubicacion = 'Teotepeque, La Libertad' WHERE usuario_id = 44;
UPDATE perfiles_chef SET ubicacion = 'Tepecoyo, La Libertad' WHERE usuario_id = 45;
UPDATE perfiles_chef SET ubicacion = 'Zaragoza, La Libertad' WHERE usuario_id = 46;
UPDATE perfiles_chef SET ubicacion = 'Chalchuapa, Santa Ana' WHERE usuario_id = 47;
UPDATE perfiles_chef SET ubicacion = 'Coatepeque, Santa Ana' WHERE usuario_id = 48;
UPDATE perfiles_chef SET ubicacion = 'El Congo, Santa Ana' WHERE usuario_id = 49;
UPDATE perfiles_chef SET ubicacion = 'El Porvenir, Santa Ana' WHERE usuario_id = 50;
UPDATE perfiles_chef SET ubicacion = 'Masahuat, Santa Ana' WHERE usuario_id = 51;
UPDATE perfiles_chef SET ubicacion = 'Metapán, Santa Ana' WHERE usuario_id = 52;
UPDATE perfiles_chef SET ubicacion = 'San Antonio Pajonal, Santa Ana' WHERE usuario_id = 53;
UPDATE perfiles_chef SET ubicacion = 'San Sebastián Salitrillo, Santa Ana' WHERE usuario_id = 54;
UPDATE perfiles_chef SET ubicacion = 'Santa Rosa Guachipilín, Santa Ana' WHERE usuario_id = 55;
UPDATE perfiles_chef SET ubicacion = 'Santiago de la Frontera, Santa Ana' WHERE usuario_id = 56;
UPDATE perfiles_chef SET ubicacion = 'Texistepeque, Santa Ana' WHERE usuario_id = 57;
UPDATE perfiles_chef SET ubicacion = 'Candelaria de la Frontera, Santa Ana' WHERE usuario_id = 58;

-- Mensaje de confirmación
SELECT 'Todas las ubicaciones de chefs actualizadas con municipios y departamentos de El Salvador' as mensaje;

-- Verificar el total de chefs con ubicaciones de El Salvador
SELECT COUNT(*) as total_chefs_el_salvador 
FROM perfiles_chef 
WHERE ubicacion LIKE '%San Salvador%' 
   OR ubicacion LIKE '%La Libertad%' 
   OR ubicacion LIKE '%Santa Ana%' 
   OR ubicacion LIKE '%San Miguel%' 
   OR ubicacion LIKE '%Ahuachapán%' 
   OR ubicacion LIKE '%Usulután%' 
   OR ubicacion LIKE '%Cuscatlán%' 
   OR ubicacion LIKE '%La Paz%' 
   OR ubicacion LIKE '%Cabañas%' 
   OR ubicacion LIKE '%Chalatenango%' 
   OR ubicacion LIKE '%La Unión%' 
   OR ubicacion LIKE '%Sonsonate%' 
   OR ubicacion LIKE '%San Vicente%' 
   OR ubicacion LIKE '%Morazán%';

-- Mostrar una muestra de las ubicaciones actualizadas
SELECT u.nombre, pc.ubicacion, pc.especialidad 
FROM usuarios u 
JOIN perfiles_chef pc ON u.id = pc.usuario_id 
WHERE u.tipo_usuario = 'chef' 
ORDER BY u.id 
LIMIT 15;