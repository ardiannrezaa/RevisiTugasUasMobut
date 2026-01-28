<?php
require_once("../db.php");

$email = trim($_POST["email"] ?? "");
$password = trim($_POST["password"] ?? "");

if ($email=="" || $password=="") {
  echo json_encode(["success"=>false, "message"=>"Email & password wajib diisi"]);
  exit;
}

$q = $conn->prepare("SELECT id,name,email,password_hash FROM users WHERE email=? LIMIT 1");
$q->bind_param("s", $email);
$q->execute();
$res = $q->get_result();

if ($res->num_rows == 0) {
  echo json_encode(["success"=>false, "message"=>"Akun tidak ditemukan"]);
  exit;
}

$row = $res->fetch_assoc();
if (password_verify($password, $row["password_hash"])) {
  echo json_encode([
    "success"=>true,
    "message"=>"Login berhasil",
    "data"=>[
      "id"=>$row["id"],
      "name"=>$row["name"],
      "email"=>$row["email"]
    ]
  ]);
} else {
  echo json_encode(["success"=>false, "message"=>"Password salah"]);
}
