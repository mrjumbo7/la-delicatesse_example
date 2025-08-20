<?php
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
    
    // Validar parámetros
    if (!isset($_GET['servicio_id']) || empty($_GET['servicio_id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID de servicio requerido']);
        exit;
    }
    
    $servicio_id = (int)$_GET['servicio_id'];
    
    $database = new Database();
    $db = $database->getConnection();
    
    // Verificar que el usuario tiene acceso a esta conversación
    $accessQuery = "SELECT c.id as conversacion_id 
                    FROM conversaciones c 
                    WHERE c.servicio_id = ? 
                    AND (c.cliente_id = ? OR c.chef_id = ?)";
    
    $accessStmt = $db->prepare($accessQuery);
    $accessStmt->bind_param('iii', $servicio_id, $user['id'], $user['id']);
    $accessStmt->execute();
    $accessResult = $accessStmt->get_result();
    
    if ($accessResult->num_rows === 0) {
        // Log para debugging
        error_log("Acceso denegado a conversación. Usuario ID: {$user['id']}, Servicio ID: $servicio_id, Tipo: {$user['tipo_usuario']}");
        
        // Verificar si el servicio existe
        $serviceCheckQuery = "SELECT id, cliente_id, chef_id, estado FROM servicios WHERE id = ?";
        $serviceStmt = $db->prepare($serviceCheckQuery);
        $serviceStmt->bind_param('i', $servicio_id);
        $serviceStmt->execute();
        $serviceResult = $serviceStmt->get_result();
        
        if ($serviceResult->num_rows === 0) {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'El servicio no existe']);
        } else {
            $service = $serviceResult->fetch_assoc();
            error_log("Servicio encontrado. Cliente: {$service['cliente_id']}, Chef: {$service['chef_id']}, Estado: {$service['estado']}");
            
            // Verificar si existe conversación para este servicio
            $convCheckQuery = "SELECT id FROM conversaciones WHERE servicio_id = ?";
            $convStmt = $db->prepare($convCheckQuery);
            $convStmt->bind_param('i', $servicio_id);
            $convStmt->execute();
            $convResult = $convStmt->get_result();
            
            if ($convResult->num_rows === 0) {
                http_response_code(404);
                echo json_encode(['success' => false, 'message' => 'No existe una conversación para este servicio. La conversación se crea automáticamente cuando el chef acepta el servicio.']);
            } else {
                http_response_code(403);
                echo json_encode(['success' => false, 'message' => 'No tienes acceso a esta conversación']);
            }
            $convStmt->close();
        }
        $serviceStmt->close();
        exit;
    }
    
    $conversacion = $accessResult->fetch_assoc();
    $conversacion_id = $conversacion['conversacion_id'];
    $accessStmt->close();
    
    // Obtener mensajes de la conversación
    $query = "SELECT m.*, 
                     ur.nombre as remitente_nombre,
                     ud.nombre as destinatario_nombre
              FROM mensajes m
              INNER JOIN usuarios ur ON m.remitente_id = ur.id
              INNER JOIN usuarios ud ON m.destinatario_id = ud.id
              WHERE m.servicio_id = ?
              ORDER BY m.fecha_envio ASC";
    
    $stmt = $db->prepare($query);
    $stmt->bind_param('i', $servicio_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $messages = [];
    while ($row = $result->fetch_assoc()) {
        $messages[] = [
            'id' => $row['id'],
            'servicio_id' => $row['servicio_id'],
            'remitente_id' => $row['remitente_id'],
            'destinatario_id' => $row['destinatario_id'],
            'remitente_nombre' => $row['remitente_nombre'],
            'destinatario_nombre' => $row['destinatario_nombre'],
            'mensaje' => $row['mensaje'],
            'leido' => (bool)$row['leido'],
            'fecha_envio' => $row['fecha_envio']
        ];
    }
    $stmt->close();
    
    // Marcar mensajes como leídos para el usuario actual
    $updateQuery = "UPDATE mensajes 
                    SET leido = 1 
                    WHERE servicio_id = ? 
                    AND destinatario_id = ? 
                    AND leido = 0";
    
    $updateStmt = $db->prepare($updateQuery);
    $updateStmt->bind_param('ii', $servicio_id, $user['id']);
    $updateStmt->execute();
    $updateStmt->close();
    
    echo json_encode([
        'success' => true,
        'data' => $messages
    ]);
    
} catch (Exception $e) {
    error_log('Error en list.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>