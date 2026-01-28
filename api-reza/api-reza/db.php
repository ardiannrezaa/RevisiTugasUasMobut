<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$host = "localhost";
$db   = "tifj4825_db_reza";
$user = "tifj4825_reza";
$pass = "R3zaS1gma";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
  echo json_encode(["success"=>false, "message"=>"DB connect failed"]);
  exit;
}
$conn->set_charset("utf8mb4");
?>
