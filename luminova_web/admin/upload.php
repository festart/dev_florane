<?php
require __DIR__ . '/config.php';
header('Content-Type: application/json; charset=utf-8');
if (empty($_SESSION['logged'])) { http_response_code(401); echo json_encode(['error'=>'unauthorized']); exit; }
if (($_SERVER['HTTP_X_CSRF'] ?? '') !== ($_SESSION['csrf'] ?? '')) { http_response_code(403); echo json_encode(['error'=>'csrf']); exit; }

if (empty($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
  http_response_code(400); echo json_encode(['error'=>'no file']); exit;
}

$allowed = ['image/png'=>'png','image/jpeg'=>'jpg','image/webp'=>'webp'];
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $_FILES['file']['tmp_name']); finfo_close($finfo);
if (!isset($allowed[$mime])) { http_response_code(400); echo json_encode(['error'=>'invalid type']); exit; }

@mkdir(UPLOAD_DIR, 0755, true);
$name = preg_replace('~[^a-zA-Z0-9._-]+~','_', $_FILES['file']['name']);
$ext  = $allowed[$mime];
if (!str_ends_with(strtolower($name), ".$ext")) $name .= ".$ext";

$dest = UPLOAD_DIR . $name;
if (!move_uploaded_file($_FILES['file']['tmp_name'], $dest)) {
  http_response_code(500); echo json_encode(['error'=>'move failed']); exit;
}

$url = '/data/images/' . $name; // URL publique
echo json_encode(['ok'=>true, 'url'=>$url]);
