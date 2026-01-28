<?php
require_once("../db.php");
$id = intval($_POST["id"] ?? 0);
$name = trim($_POST["name"] ?? "");
$brand = trim($_POST["brand"] ?? "");
$price = intval($_POST["price"] ?? 0);
$image_url = trim($_POST["image_url"] ?? "");

if ($id<=0 || $name=="" || $brand=="" || $price<=0 || $image_url=="") {
  echo json_encode(["success"=>false,"message"=>"Semua field wajib diisi"]);
  exit;
}

$q = $conn->prepare("UPDATE shoes SET name=?, brand=?, price=?, image_url=? WHERE id=?");
$q->bind_param("ssisi", $name, $brand, $price, $image_url, $id);

echo $q->execute()
 ? json_encode(["success"=>true,"message"=>"Sepatu berhasil diupdate"])
 : json_encode(["success"=>false,"message"=>"Gagal update sepatu"]);
