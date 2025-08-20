<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../../config/database.php';
require_once '../../utils/auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

try {
    $user = requireAuth();
    
    // Obtener datos del cuerpo de la petición
    $input = json_decode(file_get_contents('php://input'), true);
    
    // Validar datos requeridos
    if (!isset($input['servicio_id']) || !isset($input['mensaje'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Datos incompletos']);
        exit;
    }
    
    $servicio_id = (int)$input['servicio_id'];
    $mensaje = trim($input['mensaje']);
    
    if (empty($mensaje)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'El mensaje no puede estar vacío']);
        exit;
    }
    
    if (strlen($mensaje) > 1000) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'El mensaje es demasiado largo (máximo 1000 caracteres)']);
        exit;
    }
    
    $database = new Database();
    $db = $database->getConnection();
    
    // Verificar que existe la conversación y obtener información
    $conversationQuery = "SELECT c.id as conversacion_id, c.cliente_id, c.chef_id, c.estado
                          FROM conversaciones c 
                          WHERE c.servicio_id = ? 
                          AND (c.cliente_id = ? OR c.chef_id = ?)";
    
    $conversationStmt = $db->prepare($conversationQuery);
    $conversationStmt->bind_param('iii', $servicio_id, $user['id'], $user['id']);
    $conversationStmt->execute();
    $conversationResult = $conversationStmt->get_result();
    
    if ($conversationResult->num_rows === 0) {
        // Log para debugging
        error_log("Conversación no encontrada. Usuario ID: {$user['id']}, Servicio ID: $servicio_id, Tipo: {$user['tipo_usuario']}");
        
        // Verificar si el servicio existe y el usuario tiene acceso
        $serviceCheckQuery = "SELECT id, cliente_id, chef_id, estado FROM servicios WHERE id = ? AND (cliente_id = ? OR chef_id = ?)";
        $serviceStmt = $db->prepare($serviceCheckQuery);
        $serviceStmt->bind_param('iii', $servicio_id, $user['id'], $user['id']);
        $serviceStmt->execute();
        $serviceResult = $serviceStmt->get_result();
        
        if ($serviceResult->num_rows === 0) {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Servicio no encontrado o sin acceso']);
        } else {
            $service = $serviceResult->fetch_assoc();
            if ($service['estado'] !== 'aceptado' && $service['estado'] !== 'completado') {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'No se puede enviar mensajes. El servicio debe estar aceptado o completado para enviar mensajes.']);
            } else {
                http_response_code(404);
                echo json_encode(['success' => false, 'message' => 'Conversación no encontrada. Contacta al administrador para resolver este problema.']);
            }
        }
        $serviceStmt->close();
        exit;
    }
    
    $conversation = $conversationResult->fetch_assoc();
    $conversationStmt->close();
    
    if ($conversation['estado'] !== 'activa') {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'La conversación está cerrada']);
        exit;
    }
    
    // Determinar el destinatario
    $destinatario_id = ($user['id'] == $conversation['cliente_id']) 
                      ? $conversation['chef_id'] 
                      : $conversation['cliente_id'];
    
    // Insertar el mensaje
    $insertQuery = "INSERT INTO mensajes (servicio_id, remitente_id, destinatario_id, mensaje) 
                    VALUES (?, ?, ?, ?)";
    
    $insertStmt = $db->prepare($insertQuery);
    $insertStmt->bind_param('iiis', $servicio_id, $user['id'], $destinatario_id, $mensaje);
    
    if ($insertStmt->execute()) {
        $mensaje_id = $db->insert_id;
        $insertStmt->close();
        
        // Crear notificación para el destinatario
        $notifQuery = "INSERT INTO notificaciones (usuario_id, titulo, mensaje, tipo) 
                       VALUES (?, 'Nuevo mensaje', 'Has recibido un nuevo mensaje', 'mensaje')";
        
        $notifStmt = $db->prepare($notifQuery);
        $notifStmt->bind_param('i', $destinatario_id);
        $notifStmt->execute();
        $notifStmt->close();
        
        // Obtener información del mensaje enviado
        $getMessageQuery = "SELECT m.*, u.nombre as remitente_nombre 
                            FROM mensajes m 
                            INNER JOIN usuarios u ON m.remitente_id = u.id 
                            WHERE m.id = ?";
        
        $getMessageStmt = $db->prepare($getMessageQuery);
        $getMessageStmt->bind_param('i', $mensaje_id);
        $getMessageStmt->execute();
        $messageResult = $getMessageStmt->get_result();
        $messageData = $messageResult->fetch_assoc();
        $getMessageStmt->close();
        
        echo json_encode([
            'success' => true,
            'message' => 'Mensaje enviado correctamente',
            'data' => [
                'id' => $messageData['id'],
                'servicio_id' => $messageData['servicio_id'],
                'remitente_id' => $messageData['remitente_id'],
                'destinatario_id' => $messageData['destinatario_id'],
                'remitente_nombre' => $messageData['remitente_nombre'],
                'mensaje' => $messageData['mensaje'],
                'fecha_envio' => $messageData['fecha_envio']
            ]
        ]);
    } else {
        throw new Exception('Error al insertar el mensaje');
    }
    
} catch (Exception $e) {
    error_log('Error en send.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>