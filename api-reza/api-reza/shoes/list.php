<?php
require_once("../db.php");

$res = $conn->query("SELECT id,name,brand,price,image_url,created_at FROM shoes ORDER BY id DESC");
$data = [];
while ($row = $res->fetch_assoc()) {
  $data[] = $row;
}
echo json_encode(["success"=>true, "data"=>$data]);
