<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../../config/database.php';

try {
    $database = new Database();
    $db = $database->getConnection();
    
    $chef_id = isset($_GET['id']) ? $_GET['id'] : null;
    $language = isset($_GET['language']) ? $_GET['language'] : 'es';
    
    // Construir query con soporte para traducción
    if ($language === 'es') {
        $query = "SELECT u.id, u.nombre, u.email, u.telefono,
                         p.especialidad, p.experiencia_anos, p.precio_por_hora,
                         p.biografia, p.ubicacion, p.certificaciones, p.foto_perfil,
                         p.calificacion_promedio, p.total_servicios
                  FROM usuarios u
                  INNER JOIN perfiles_chef p ON u.id = p.usuario_id
                  WHERE u.tipo_usuario = 'chef' AND u.activo = 1";
    } else {
        $query = "SELECT u.id, u.nombre, u.email, u.telefono,
                         COALESCE(t.especialidad, p.especialidad) as especialidad,
                         p.experiencia_anos, p.precio_por_hora,
                         COALESCE(t.descripcion, p.biografia) as biografia,
                         p.ubicacion, p.certificaciones, p.foto_perfil,
                         p.calificacion_promedio, p.total_servicios
                  FROM usuarios u
                  INNER JOIN perfiles_chef p ON u.id = p.usuario_id
                  LEFT JOIN traducciones_perfil_chef t ON u.id = t.perfil_chef_id AND t.idioma = ?
                  WHERE u.tipo_usuario = 'chef' AND u.activo = 1";
    }
    
    if ($chef_id) {
        $query .= " AND u.id = ?";
    }
    
    $query .= " ORDER BY p.calificacion_promedio DESC, p.total_servicios DESC";
    
    $stmt = $db->prepare($query);
    
    // Bind parameters según el idioma y filtros
    if ($language !== 'es' && $chef_id) {
        $stmt->bind_param('si', $language, $chef_id);
    } elseif ($language !== 'es') {
        $stmt->bind_param('s', $language);
    } elseif ($chef_id) {
        $stmt->bind_param('i', $chef_id);
    }
    // Si es español y no hay chef_id, no necesita parámetros
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    $chefs = [];
    while ($row = $result->fetch_assoc()) {
        $chefs[] = $row;
    }
    $stmt->close();
    
    echo json_encode([
        'success' => true,
        'data' => $chefs
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
