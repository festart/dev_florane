<?php
require __DIR__ . '/config.php';
if (empty($_SESSION['logged'])) { http_response_code(401); exit('Unauthorized'); }

$file = $_GET['file'] ?? '';
if (!$file) { http_response_code(400); exit('Missing file'); }

// Si l'URL est absolue (http/https), on laisse le navigateur la télécharger
if (preg_match('~^https?://~i', $file)) {
  header('Location: ' . $file);
  exit;
}

// Normaliser : n'autoriser que les fichiers situés dans /data/images/
$base = realpath(UPLOAD_DIR);             // ex: /…/data/images/
$target = realpath($base . '/' . basename($file)); // évite ../
if ($target === false || strpos($target, $base) !== 0 || !is_file($target)) {
  http_response_code(404); exit('Not found');
}

// Déterminer le type MIME
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $target) ?: 'application/octet-stream';
finfo_close($finfo);

header('Content-Type: ' . $mime);
header('Content-Length: ' . filesize($target));
header('Content-Disposition: attachment; filename="' . basename($target) . '"');
header('Cache-Control: no-store');

readfile($target);
