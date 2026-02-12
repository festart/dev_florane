<?php
// Admin config
session_start();

// Chemins
define('DATA_JSON', __DIR__ . '/../data/json/adress.json');
define('UPLOAD_DIR', __DIR__ . '/../data/images/');

// Identifiant fixe + mot de passe hashé (bcrypt)
const ADMIN_USER = 'Luminovadmin';
// Génère ton propre hash: php -r "echo password_hash('TON_MDP', PASSWORD_BCRYPT), PHP_EOL;"
const ADMIN_PASS_HASH = '$2y$12$ImISpqcSnjJKHCg5ww46GeP/WPCnF5dDxnsao3i.0agC4HllHjEs6'; 

// Forcer HTTPS (désactivable si besoin)
if (empty($_SERVER['HTTPS']) || $_SERVER['HTTPS'] === 'off') {
  // header('Location: https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI']);
}
