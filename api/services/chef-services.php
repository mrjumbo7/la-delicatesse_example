<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../../config/database.php';
require_once '../../utils/auth.php';

try {
    $user = requireAuth();
    
    if ($user['tipo_usuario'] !== 'chef') {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'Acceso denegado']);
        exit;
    }
    
    $database = new Database();
    $db = $database->getConnection();
    
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Obtener servicios del chef
        $query = "SELECT s.*, 
                         u.nombre as cliente_nombre,
                         u.telefono as cliente_telefono,
                         u.email as cliente_email
                  FROM servicios s
                  INNER JOIN usuarios u ON s.cliente_id = u.id
                  WHERE s.chef_id = ?
                  ORDER BY s.fecha_servicio ASC, s.hora_servicio ASC";
        
        $stmt = $db->prepare($query);
        $stmt->bind_param('i', $user['id']);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $services = [];
        while ($row = $result->fetch_assoc()) {
            $services[] = $row;
        }
        $stmt->close();
        
        echo json_encode([
            'success' => true,
            'data' => $services
        ]);
        
    } elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
        // Actualizar estado del servicio
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($input['service_id']) || !isset($input['estado'])) {
            echo json_encode(['success' => false, 'message' => 'Datos incompletos']);
            exit;
        }
        
        $service_id = $input['service_id'];
        $nuevo_estado = $input['estado'];
        $motivo = $input['motivo'] ?? null;
        
        // Validar que el servicio pertenece al chef
        $checkQuery = "SELECT cliente_id FROM servicios WHERE id = ? AND chef_id = ?";
        $checkStmt = $db->prepare($checkQuery);
        $checkStmt->bind_param('ii', $service_id, $user['id']);
        $checkStmt->execute();
        $result = $checkStmt->get_result();
        
        if ($result->num_rows === 0) {
            echo json_encode(['success' => false, 'message' => 'Servicio no encontrado']);
            exit;
        }
        
        $service_data = $result->fetch_assoc();
        $cliente_id = $service_data['cliente_id'];
        $checkStmt->close();
        
        // Actualizar estado del servicio
        $updateQuery = "UPDATE servicios SET estado = ? WHERE id = ? AND chef_id = ?";
        $updateStmt = $db->prepare($updateQuery);
        $updateStmt->bind_param('sii', $nuevo_estado, $service_id, $user['id']);
        
        if ($updateStmt->execute()) {
            $updateStmt->close();
            
            // Crear notificación para el cliente
            $mensaje_notif = "";
            switch ($nuevo_estado) {
                case 'aceptado':
                    $mensaje_notif = "Tu solicitud de servicio ha sido aceptada por el chef.";
                    break;
                case 'rechazado':
                    $mensaje_notif = "Tu solicitud de servicio ha sido rechazada." . ($motivo ? " Motivo: $motivo" : "");
                    break;
                case 'completado':
                    $mensaje_notif = "El servicio ha sido completado. ¡Esperamos que hayas disfrutado la experiencia!";
                    break;
                case 'cancelado':
                    $mensaje_notif = "El servicio ha sido cancelado." . ($motivo ? " Motivo: $motivo" : "");
                    break;
            }
            
            if ($mensaje_notif) {
                $notifQuery = "INSERT INTO notificaciones (usuario_id, titulo, mensaje, tipo) 
                              VALUES (?, 'Actualización de servicio', ?, 'servicio')";
                $notifStmt = $db->prepare($notifQuery);
                $notifStmt->bind_param('is', $cliente_id, $mensaje_notif);
                $notifStmt->execute();
                $notifStmt->close();
            }
            
            // Crear conversación automáticamente cuando el servicio es aceptado
            if ($nuevo_estado === 'aceptado') {
                try {
                    // Verificar si ya existe una conversación para este servicio
                    $checkConvQuery = "SELECT id FROM conversaciones WHERE servicio_id = ?";
                    $checkStmt = $db->prepare($checkConvQuery);
                    $checkStmt->bind_param('i', $service_id);
                    $checkStmt->execute();
                    $checkResult = $checkStmt->get_result();
                    
                    if ($checkResult->num_rows === 0) {
                        // No existe conversación, crear una nueva
                        $conversationQuery = "INSERT INTO conversaciones (servicio_id, cliente_id, chef_id, estado) 
                                             VALUES (?, ?, ?, 'activa')";
                        $conversationStmt = $db->prepare($conversationQuery);
                        $conversationStmt->bind_param('iii', $service_id, $cliente_id, $user['id']);
                        
                        if ($conversationStmt->execute()) {
                            $conversacion_id = $db->insert_id;
                            error_log("Conversación creada exitosamente. ID: $conversacion_id, Servicio: $service_id");
                            
                            // Enviar mensaje automático de bienvenida
                            $welcomeMessage = "¡Hola! Tu servicio ha sido aceptado. Puedes usar este chat para coordinar los detalles del evento. ¡Estoy emocionado de trabajar contigo!";
                            
                            $welcomeMsgQuery = "INSERT INTO mensajes (conversacion_id, remitente_id, destinatario_id, mensaje) 
                                               VALUES (?, ?, ?, ?)";
                            $welcomeMsgStmt = $db->prepare($welcomeMsgQuery);
                            $welcomeMsgStmt->bind_param('iiis', $conversacion_id, $user['id'], $cliente_id, $welcomeMessage);
                            
                            if ($welcomeMsgStmt->execute()) {
                                error_log("Mensaje de bienvenida enviado exitosamente para conversación: $conversacion_id");
                            } else {
                                error_log("Error al enviar mensaje de bienvenida: " . $welcomeMsgStmt->error);
                            }
                            $welcomeMsgStmt->close();
                        } else {
                            error_log("Error al crear conversación para servicio $service_id: " . $conversationStmt->error);
                        }
                        $conversationStmt->close();
                    } else {
                        $existingConv = $checkResult->fetch_assoc();
                        error_log("Conversación ya existe para servicio $service_id. ID: " . $existingConv['id']);
                    }
                    $checkStmt->close();
                } catch (Exception $convError) {
                    error_log("Error en creación de conversación: " . $convError->getMessage());
                }
            }
            
            echo json_encode(['success' => true, 'message' => 'Estado actualizado correctamente']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Error al actualizar el estado']);
        }
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>