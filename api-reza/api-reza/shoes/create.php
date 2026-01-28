<?php
require_once("../db.php");
$name = trim($_POST["name"] ?? "");
$brand = trim($_POST["brand"] ?? "");
$price = intval($_POST["price"] ?? 0);
$image_url = trim($_POST["image_url"] ?? "");

if ($name=="" || $brand=="" || $price<=0 || $image_url=="") {
  echo json_encode(["success"=>false,"message"=>"Semua field wajib diisi"]);
  exit;
}

$q = $conn->prepare("INSERT INTO shoes(name,brand,price,image_url) VALUES (?,?,?,?)");
$q->bind_param("ssis", $name, $brand, $price, $image_url);

echo $q->execute()
 ? json_encode(["success"=>true,"message"=>"Sepatu berhasil ditambah"])
 : json_encode(["success"=>false,"message"=>"Gagal tambah sepatu"]);
