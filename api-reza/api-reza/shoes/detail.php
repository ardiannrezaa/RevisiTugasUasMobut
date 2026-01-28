<?php
require_once("../db.php");
$id = intval($_GET["id"] ?? 0);

$res = $conn->query("SELECT * FROM shoes WHERE id=$id LIMIT 1");
if ($res && $res->num_rows > 0) {
  echo json_encode(["success"=>true, "data"=>$res->fetch_assoc()]);
} else {
  echo json_encode(["success"=>false, "message"=>"Data tidak ditemukan"]);
}
