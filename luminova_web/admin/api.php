<?php
require __DIR__ . '/config.php';
if (empty($_SESSION['logged'])) { http_response_code(401); exit; }
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  if (!file_exists(DATA_JSON)) { echo "[]"; exit; }
  header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
  readfile(DATA_JSON); exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  if (($_SERVER['HTTP_X_CSRF'] ?? '') !== ($_SESSION['csrf'] ?? '')) {
    http_response_code(403); echo json_encode(['error'=>'csrf']); exit;
  }
  $raw = file_get_contents('php://input');
  $data = json_decode($raw, true);
  if (!is_array($data)) { http_response_code(400); echo json_encode(['error'=>'invalid json']); exit; }
  @mkdir(dirname(DATA_JSON), 0755, true);
  $tmp = DATA_JSON.'.tmp';
  if (file_put_contents($tmp, json_encode($data, JSON_UNESCAPED_SLASHES|JSON_PRETTY_PRINT)) === false) {
    http_response_code(500); echo json_encode(['error'=>'write failed']); exit;
  }
  rename($tmp, DATA_JSON);
  echo json_encode(['ok'=>true]); exit;
}

http_response_code(405);
