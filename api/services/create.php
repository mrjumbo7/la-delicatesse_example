<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once '../../config/database.php';
require_once '../../utils/auth.php';
require_once '../../utils/translate.php';
require_once '../../config/api_keys.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

try {
    $user = requireAuth();
    
    $database = new Database();
    $db = $database->getConnection();
    
    $input = json_decode(file_get_contents('php://input'), true);
    
    $chef_id = $input['chef_id'] ?? '';
    $fecha_servicio = $input['fecha_servicio'] ?? '';
    $hora_servicio = $input['hora_servicio'] ?? '';
    $ubicacion_servicio = $input['ubicacion_servicio'] ?? '';
    $numero_comensales = $input['numero_comensales'] ?? '';
    $duracion_estimada = $input['duracion_estimada'] ?? 4;
    $descripcion_evento = $input['descripcion_evento'] ?? '';
    
    // Validaciones
    if (empty($chef_id) || empty($fecha_servicio) || empty($hora_servicio) || 
        empty($ubicacion_servicio) || empty($numero_comensales)) {
        echo json_encode(['success' => false, 'message' => 'Todos los campos son requeridos']);
        exit;
    }
    
    // Validar número de comensales - si es 'mas', convertir a un número válido
    if ($numero_comensales === 'mas') {
        $numero_comensales = 15; // Valor por defecto para 'más de 10'
    }
    
    // Asegurar que numero_comensales sea un entero válido
    $numero_comensales = (int)$numero_comensales;
    if ($numero_comensales <= 0) {
        echo json_encode(['success' => false, 'message' => 'Número de comensales inválido']);
        exit;
    }
    
    // Obtener precio del chef
    $priceQuery = "SELECT precio_por_hora FROM perfiles_chef WHERE usuario_id = ?";
    $priceStmt = $db->prepare($priceQuery);
    if (!$priceStmt) {
        error_log('Error preparando query de precio: ' . $db->error);
        echo json_encode(['success' => false, 'message' => 'Error preparando consulta de precio']);
        exit;
    }
    $priceStmt->bind_param('i', $chef_id);
    $priceStmt->execute();
    $result = $priceStmt->get_result();
    $chefData = $result->fetch_assoc();
    $priceStmt->close();
    
    if (!$chefData) {
        echo json_encode(['success' => false, 'message' => 'Chef no encontrado o perfil incompleto']);
        exit;
    }
    
    // Calcular precio total usando la duración estimada
    $precio_total = $chefData['precio_por_hora'] * $duracion_estimada;
    
    // Crear servicio (duracion_estimada se usa solo para calcular precio, no se guarda en DB)
    $insertQuery = "INSERT INTO servicios (cliente_id, chef_id, fecha_servicio, hora_servicio, 
                                         ubicacion_servicio, numero_comensales, precio_total, 
                                         descripcion_evento, estado) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')";
    
    $insertStmt = $db->prepare($insertQuery);
    if (!$insertStmt) {
        error_log('Error preparando query de inserción: ' . $db->error);
        echo json_encode(['success' => false, 'message' => 'Error preparando consulta: ' . $db->error]);
        exit;
    }
    
    $insertStmt->bind_param('iisssiis', $user['id'], $chef_id, $fecha_servicio, $hora_servicio, 
                           $ubicacion_servicio, $numero_comensales, $precio_total, $descripcion_evento);
    
    if ($insertStmt->execute()) {
        $serviceId = $db->insert_id;
        $insertStmt->close();
        
        // Traducir descripción del evento al inglés
        if (!empty($descripcion_evento)) {
            try {
                $translator = new Translator(APIKeys::getRapidAPIKey());
                $translatedDescription = $translator->translate($descripcion_evento);
                
                // Guardar traducción
                $translationQuery = "INSERT INTO traducciones_servicios 
                                   (servicio_id, idioma, descripcion_evento) 
                                   VALUES (?, 'en', ?)";
                $translationStmt = $db->prepare($translationQuery);
                $translationStmt->bind_param('is', $serviceId, $translatedDescription);
                $translationStmt->execute();
                $translationStmt->close();
                
            } catch (Exception $e) {
                error_log("Error en traducción de servicio: " . $e->getMessage());
            }
        }
        
        // Crear notificación para el chef
        $notifQuery = "INSERT INTO notificaciones (usuario_id, titulo, mensaje, tipo) 
                       VALUES (?, 'Nueva solicitud de servicio', 
                              'Tienes una nueva solicitud de servicio pendiente', 'servicio')";
        $notifStmt = $db->prepare($notifQuery);
        $notifStmt->bind_param('i', $chef_id);
        $notifStmt->execute();
        $notifStmt->close();
        
        echo json_encode([
            'success' => true,
            'message' => 'Servicio solicitado exitosamente',
            'service_id' => $serviceId,
            'precio_total' => $precio_total
        ]);
    } else {
        error_log('Error ejecutando inserción: ' . $insertStmt->error);
        $insertStmt->close();
        echo json_encode(['success' => false, 'message' => 'Error al crear servicio: ' . $insertStmt->error]);
    }
    
} catch (Exception $e) {
    http_response_code(500);
    error_log('Error en create.php: ' . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor: ' . $e->getMessage()]);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>
