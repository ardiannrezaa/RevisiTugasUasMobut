<?php
require_once("../db.php");
$id = intval($_POST["id"] ?? 0);
$title = trim($_POST["title"] ?? "");
$content = trim($_POST["content"] ?? "");

if ($id<=0 || $title=="" || $content=="") {
  echo json_encode(["success"=>false,"message"=>"Semua field wajib diisi"]);
  exit;
}

$q = $conn->prepare("UPDATE articles SET title=?, content=? WHERE id=?");
$q->bind_param("ssi", $title, $content, $id);

echo $q->execute()
 ? json_encode(["success"=>true,"message"=>"Artikel berhasil diupdate"])
 : json_encode(["success"=>false,"message"=>"Gagal update artikel"]);
