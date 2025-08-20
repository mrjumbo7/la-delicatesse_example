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
    
    // Solo administradores pueden crear categorías
    if ($user['tipo_usuario'] !== 'admin') {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'No tienes permisos para crear categorías']);
        exit;
    }
    
    $database = new Database();
    $db = $database->getConnection();
    
    $input = json_decode(file_get_contents('php://input'), true);
    
    $nombre = $input['nombre'] ?? '';
    $descripcion = $input['descripcion'] ?? '';
    
    if (empty($nombre)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'El nombre de la categoría es requerido']);
        exit;
    }
    
    // Verificar si la categoría ya existe
    $checkQuery = "SELECT id FROM categorias WHERE nombre = ?";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bind_param('s', $nombre);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    
    if ($checkResult->num_rows > 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Ya existe una categoría con ese nombre']);
        exit;
    }
    
    $checkStmt->close();
    
    // Insertar nueva categoría
    $query = "INSERT INTO categorias (nombre, descripcion, fecha_creacion) VALUES (?, ?, NOW())";
    $stmt = $db->prepare($query);
    $stmt->bind_param('ss', $nombre, $descripcion);
    
    if ($stmt->execute()) {
        $categoriaId = $db->insert_id;
        
        // Traducir automáticamente al inglés
        try {
            $translator = new Translator(APIKeys::getRapidAPIKey());
            
            $textsToTranslate = [
                'nombre' => $nombre,
                'descripcion' => $descripcion
            ];
            
            $translations = $translator->translateArray($textsToTranslate);
            
            // Guardar traducción al inglés
            $translationQuery = "INSERT INTO traducciones_categorias 
                               (categoria_id, idioma, nombre, descripcion) 
                               VALUES (?, 'en', ?, ?)";
            $translationStmt = $db->prepare($translationQuery);
            $translationStmt->bind_param('iss', $categoriaId, $translations['nombre'], $translations['descripcion']);
            $translationStmt->execute();
            $translationStmt->close();
            
        } catch (Exception $e) {
            error_log("Error en traducción de categoría: " . $e->getMessage());
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Categoría creada exitosamente',
            'categoria_id' => $categoriaId
        ]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al crear la categoría']);
    }
    
    $stmt->close();
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>