<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    $service_id = $_GET['service_id'] ?? null;
    $language = $_GET['language'] ?? 'es';

    if (!$service_id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID de servicio requerido']);
        exit;
    }

    // Si el idioma es español, obtener datos originales
    if ($language === 'es') {
        $query = "SELECT s.*, 
                         uc.nombre as cliente_nombre, 
                         uch.nombre as chef_nombre 
                 FROM servicios s 
                 JOIN usuarios uc ON s.cliente_id = uc.id 
                 JOIN usuarios uch ON s.chef_id = uch.id 
                 WHERE s.id = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param('i', $service_id);
    } else {
        // Para otros idiomas, intentar obtener traducción
        $query = "SELECT 
                    s.id, s.cliente_id, s.chef_id, s.fecha_servicio, s.hora_servicio,
                    s.ubicacion_servicio, s.numero_comensales, s.precio_total, s.estado, s.fecha_creacion,
                    COALESCE(t.descripcion_evento, s.descripcion_evento) as descripcion_evento,
                    uc.nombre as cliente_nombre,
                    uch.nombre as chef_nombre
                 FROM servicios s 
                 LEFT JOIN traducciones_servicios t ON s.id = t.servicio_id AND t.idioma = ?
                 JOIN usuarios uc ON s.cliente_id = uc.id 
                 JOIN usuarios uch ON s.chef_id = uch.id 
                 WHERE s.id = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param('si', $language, $service_id);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Servicio no encontrado']);
        exit;
    }

    $service = $result->fetch_assoc();
    $stmt->close();

    echo json_encode([
        'success' => true,
        'service' => $service
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
