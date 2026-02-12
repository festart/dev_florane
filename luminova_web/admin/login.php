<?php
require __DIR__ . '/config.php';

if (isset($_SESSION['logged']) && $_SESSION['logged'] === true) {
  header('Location: /admin/'); exit;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $u = $_POST['user'] ?? '';
  $p = $_POST['pass'] ?? '';
  if ($u === ADMIN_USER && password_verify($p, ADMIN_PASS_HASH)) {
    $_SESSION['logged'] = true;
    $_SESSION['csrf'] = bin2hex(random_bytes(16));
    header('Location: /admin/'); exit;
  } else {
    $error = 'Identifiants invalides';
  }
}
?><!doctype html>
<html lang="fr"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Connexion admin</title>
<style>
  body{font-family:system-ui,Arial;margin:40px;display:grid;place-items:center}
  form{width:320px;padding:24px;border:1px solid #ddd;border-radius:12px}
  input{width:100%;padding:10px;margin:8px 0}
  button{padding:10px 14px;cursor:pointer;width:100%}
  .err{color:#b00;margin:8px 0 0}
</style>
<form method="post" autocomplete="off">
  <h2>Admin – Connexion</h2>
  <input name="user" placeholder="Utilisateur" required>
  <input name="pass" type="password" placeholder="Mot de passe" required>
  <button type="submit">Se connecter</button>
  <?php if ($error): ?><div class="err"><?=htmlspecialchars($error)?></div><?php endif; ?>
</form>
</html>
