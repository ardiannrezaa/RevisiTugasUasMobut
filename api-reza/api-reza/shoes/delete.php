<?php
require_once("../db.php");
$id = intval($_POST["id"] ?? 0);
if ($id<=0) { echo json_encode(["success"=>false,"message"=>"ID tidak valid"]); exit; }

echo $conn->query("DELETE FROM shoes WHERE id=$id")
 ? json_encode(["success"=>true,"message"=>"Sepatu berhasil dihapus"])
 : json_encode(["success"=>false,"message"=>"Gagal hapus sepatu"]);
