<?php
require __DIR__ . '/config.php';
if (empty($_SESSION['logged'])) { http_response_code(401); exit('Unauthorized'); }

$dir = realpath(UPLOAD_DIR);
if (!$dir || !is_dir($dir)) { echo json_encode([]); exit; }

$baseUrl = rtrim((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' ? 'https://' : 'http://')
  . $_SERVER['HTTP_HOST'], '/');

$files = [];
$dh = opendir($dir);
while (($f = readdir($dh)) !== false) {
  if ($f === '.' || $f === '..') continue;
  $path = $dir . DIRECTORY_SEPARATOR . $f;
  if (is_file($path)) {
    // on renvoie: name, chemin relatif et url absolue
    $rel = '/data/images/' . $f;
    $files[] = [
      'name' => $f,
      'path' => $rel,
      'url'  => $baseUrl . $rel,
    ];
  }
}
closedir($dh);

header('Content-Type: application/json; charset=utf-8');
echo json_encode($files);
