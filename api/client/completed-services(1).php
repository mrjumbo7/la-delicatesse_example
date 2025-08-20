<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../../config/database.php';
require_once '../../utils/auth.php';

// Verificar autenticación
$user = requireAuth();

// Verificar que el usuario sea un cliente
if ($user['tipo_usuario'] !== 'cliente') {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Acceso denegado. Solo los clientes pueden acceder a esta función.']);
    exit;
}

// Obtener el ID del usuario autenticado
$userId = $user['id'];

// Conectar a la base de datos
$db = new Database();
$conn = $db->getConnection();

try {
    // Obtener servicios completados que no han sido calificados
    $stmt = $conn->prepare("
        SELECT s.id, s.fecha_servicio, s.hora_servicio, s.ubicacion_servicio, 
               s.numero_comensales, s.precio_total, s.descripcion_evento,
               u.id as chef_id, u.nombre as chef_nombre, u.email as chef_email,
               pc.foto_perfil as chef_foto,
               CASE WHEN c.id IS NOT NULL THEN 1 ELSE 0 END as ya_calificado
        FROM servicios s
        JOIN usuarios u ON s.chef_id = u.id
        LEFT JOIN perfiles_chef pc ON u.id = pc.usuario_id
        LEFT JOIN calificaciones c ON s.id = c.servicio_id AND c.cliente_id = ?
        WHERE s.cliente_id = ? AND s.estado = 'completado'
        ORDER BY s.fecha_servicio DESC
    ");
    $stmt->bind_param("ii", $userId, $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $services = [];
    while ($row = $result->fetch_assoc()) {
        $services[] = $row;
    }
    
    // Devolver respuesta exitosa
    echo json_encode(['success' => true, 'data' => $services]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error al obtener servicios: ' . $e->getMessage()]);
}

// Cerrar conexión
$conn->close();
?>