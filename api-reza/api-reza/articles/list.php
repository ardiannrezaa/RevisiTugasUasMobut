<?php
require_once("../db.php");

$res = $conn->query("SELECT id,title,content,created_at FROM articles ORDER BY id DESC");
$data = [];
while ($row = $res->fetch_assoc()) {
  $data[] = $row;
}
echo json_encode(["success"=>true, "data"=>$data]);
