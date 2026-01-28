<?php
require_once("../db.php");

$name = trim($_POST["name"] ?? "");
$email = trim($_POST["email"] ?? "");
$password = trim($_POST["password"] ?? "");

if ($name=="" || $email=="" || $password=="") {
  echo json_encode(["success"=>false, "message"=>"Semua field wajib diisi"]);
  exit;
}

$cek = $conn->prepare("SELECT id FROM users WHERE email=?");
$cek->bind_param("s", $email);
$cek->execute();
$cekRes = $cek->get_result();
if ($cekRes->num_rows > 0) {
  echo json_encode(["success"=>false, "message"=>"Email sudah terdaftar"]);
  exit;
}

$hash = password_hash($password, PASSWORD_BCRYPT);

$q = $conn->prepare("INSERT INTO users(name,email,password_hash) VALUES (?,?,?)");
$q->bind_param("sss", $name, $email, $hash);

if ($q->execute()) {
  echo json_encode(["success"=>true, "message"=>"Register berhasil"]);
} else {
  echo json_encode(["success"=>false, "message"=>"Register gagal"]);
}
