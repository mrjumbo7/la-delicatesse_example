<?php
require_once '../../config/error_config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../../config/database.php';
require_once '../../utils/auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

try {
    $user = requireAuth();
    
    $database = new Database();
    $db = $database->getConnection();
    
    if (!$db) {
        throw new Exception('No se pudo conectar a la base de datos');
    }
    
    // Obtener conversaciones según el tipo de usuario
    if ($user['tipo_usuario'] === 'cliente') {
        // Para clientes: mostrar conversaciones con chefs
        $query = "SELECT c.*, 
                         s.id as servicio_id,
                         u.nombre as otro_usuario, 
                         u.id as otro_usuario_id,
                         (
                             SELECT m.mensaje 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             ORDER BY m.fecha_envio DESC 
                             LIMIT 1
                         ) as ultimo_mensaje,
                         (
                             SELECT m.fecha_envio 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             ORDER BY m.fecha_envio DESC 
                             LIMIT 1
                         ) as fecha_ultimo,
                         (
                             SELECT COUNT(*) 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             AND m.destinatario_id = ? 
                             AND m.leido = 0
                         ) as mensajes_no_leidos
                  FROM conversaciones c
                  INNER JOIN usuarios u ON c.chef_id = u.id
                  INNER JOIN servicios s ON c.servicio_id = s.id
                  WHERE c.cliente_id = ?
                  ORDER BY c.fecha_actualizacion DESC";
        
        $stmt = $db->prepare($query);
        $stmt->bind_param('ii', $user['id'], $user['id']);
    } else {
        // Para chefs: mostrar conversaciones con clientes
        $query = "SELECT c.*, 
                         s.id as servicio_id,
                         u.nombre as otro_usuario, 
                         u.id as otro_usuario_id,
                         (
                             SELECT m.mensaje 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             ORDER BY m.fecha_envio DESC 
                             LIMIT 1
                         ) as ultimo_mensaje,
                         (
                             SELECT m.fecha_envio 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             ORDER BY m.fecha_envio DESC 
                             LIMIT 1
                         ) as fecha_ultimo,
                         (
                             SELECT COUNT(*) 
                             FROM mensajes m 
                             WHERE m.servicio_id = c.servicio_id 
                             AND m.destinatario_id = ? 
                             AND m.leido = 0
                         ) as mensajes_no_leidos
                  FROM conversaciones c
                  INNER JOIN usuarios u ON c.cliente_id = u.id
                  INNER JOIN servicios s ON c.servicio_id = s.id
                  WHERE c.chef_id = ?
                  ORDER BY c.fecha_actualizacion DESC";
        
        $stmt = $db->prepare($query);
        $stmt->bind_param('ii', $user['id'], $user['id']);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    $conversations = [];
    while ($row = $result->fetch_assoc()) {
        $conversations[] = [
            'id' => $row['id'],
            'servicio_id' => $row['servicio_id'],
            'chef_nombre' => $row['otro_usuario'], // Usar chef_nombre para compatibilidad con el frontend
            'otro_usuario' => $row['otro_usuario'],
            'otro_usuario_id' => $row['otro_usuario_id'],
            'ultimo_mensaje' => $row['ultimo_mensaje'] ?: 'No hay mensajes aún',
            'fecha_ultimo' => $row['fecha_ultimo'],
            'fecha_actualizacion' => $row['fecha_ultimo'], // Agregar fecha_actualizacion
            'mensajes_no_leidos' => (int)$row['mensajes_no_leidos'],
            'estado' => $row['estado']
        ];
    }
    $stmt->close();
    
    echo json_encode([
        'success' => true,
        'data' => $conversations
    ]);
    
} catch (Exception $e) {
    error_log('Error en conversations.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>