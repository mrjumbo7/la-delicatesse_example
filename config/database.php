<?php
require_once __DIR__ . '/error_config.php';

class Database {
    private $host = 'localhost';
    private $db_name = 'la_delicatesse';
    private $username = 'root';
    private $password = '';
    public $conn;

    public function getConnection() {
        $this->conn = null;
        try {
            $this->conn = new mysqli($this->host, $this->username, $this->password, $this->db_name);
            $this->conn->set_charset("utf8");
            
            if ($this->conn->connect_error) {
                throw new Exception("Error de conexión: " . $this->conn->connect_error);
            }
        } catch(Exception $exception) {
            error_log("Error de conexión a la base de datos: " . $exception->getMessage());
            throw $exception;
        }
        return $this->conn;
    }
}
?>
