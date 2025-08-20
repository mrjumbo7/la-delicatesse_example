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
    
    $language = $_GET['language'] ?? 'es';
    
    // Construir query con soporte para traducción
    if ($language === 'es') {
        $query = "SELECT * FROM categorias ORDER BY nombre ASC";
        $stmt = $db->prepare($query);
    } else {
        $query = "SELECT 
                    c.id, c.fecha_creacion,
                    COALESCE(t.nombre, c.nombre) as nombre,
                    COALESCE(t.descripcion, c.descripcion) as descripcion
                  FROM categorias c
                  LEFT JOIN traducciones_categorias t ON c.id = t.categoria_id AND t.idioma = ?
                  ORDER BY COALESCE(t.nombre, c.nombre) ASC";
        $stmt = $db->prepare($query);
        $stmt->bind_param('s', $language);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    $categories = [];
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
    
    $stmt->close();
    
    echo json_encode([
        'success' => true,
        'data' => $categories
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error interno del servidor']);
} finally {
    if (isset($db)) {
        $db->close();
    }
}
?>