<?php
require_once("../db.php");
$title = trim($_POST["title"] ?? "");
$content = trim($_POST["content"] ?? "");

if ($title=="" || $content=="") {
  echo json_encode(["success"=>false,"message"=>"Judul dan isi wajib diisi"]);
  exit;
}

$q = $conn->prepare("INSERT INTO articles(title,content) VALUES (?,?)");
$q->bind_param("ss", $title, $content);

echo $q->execute()
 ? json_encode(["success"=>true,"message"=>"Artikel berhasil ditambah"])
 : json_encode(["success"=>false,"message"=>"Gagal tambah artikel"]);
