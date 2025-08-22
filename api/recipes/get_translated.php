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
    
    $recipe_id = $_GET['recipe_id'] ?? null;
    $language = $_GET['language'] ?? 'es';
    
    if (!$recipe_id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID de receta requerido']);
        exit;
    }
    
    // Si el idioma es español, obtener datos originales
    if ($language === 'es') {
        $query = "SELECT r.*, u.nombre as chef_nombre 
                 FROM recetas r 
                 JOIN usuarios u ON r.chef_id = u.id 
                 WHERE r.id = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param('i', $recipe_id);
    } else {
        // Para otros idiomas, intentar obtener traducción
        $query = "SELECT 
                    r.id, r.chef_id, r.tiempo_preparacion, r.dificultad, r.precio, r.imagen, r.fecha_publicacion,
                    COALESCE(t.titulo, r.titulo) as titulo,
                    COALESCE(t.descripcion, r.descripcion) as descripcion,
                    COALESCE(t.ingredientes, r.ingredientes) as ingredientes,
                    COALESCE(t.instrucciones, r.instrucciones) as instrucciones,
                    u.nombre as chef_nombre
                 FROM recetas r 
                 LEFT JOIN traducciones_recetas t ON r.id = t.receta_id AND t.idioma = ?
                 JOIN usuarios u ON r.chef_id = u.id 
                 WHERE r.id = ?";
        $stmt = $db->prepare($query);
        $stmt->bind_param('si', $language, $recipe_id);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Receta no encontrada']);
        exit;
    }
    
    $recipe = $result->fetch_assoc();
    $stmt->close();
    
    echo json_encode([
        'success' => true,
        'data' => $recipe
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor', 'error' => $e->getMessage()]);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>