<?php
require __DIR__ . '/config.php';
if (empty($_SESSION['logged'])) { header('Location: /admin/login.php'); exit; }

// Crée les dossiers si besoin
@mkdir(dirname(DATA_JSON), 0755, true);
@mkdir(UPLOAD_DIR, 0755, true);
$csrf = $_SESSION['csrf'] ?? bin2hex(random_bytes(16));
$_SESSION['csrf'] = $csrf;
?>
<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Adresses (adress.json)</title>
<style>
  :root { --gap:12px; --b:#e6e6e6; --bg:#fafafa; }
  body{font-family:system-ui,Arial;margin:24px;max-width:1100px}
  h1{margin:0 0 16px}
  .toolbar{display:flex;gap:var(--gap);align-items:center;margin-bottom:16px}
  .toolbar .right{margin-left:auto}
  .btn{padding:8px 12px;border:1px solid var(--b);border-radius:8px;background:#fff;cursor:pointer}
  .btn.primary{background:#1266f1;color:#fff;border-color:#1266f1}
  .msg{margin:8px 0 0}
  .list{display:flex;flex-direction:column;gap:10px}
  .row{display:grid;grid-template-columns:0.8fr 0.8fr 1.3fr 1.4fr auto;gap:var(--gap);padding:12px;border:1px solid var(--b);border-radius:10px;background:#fff}
  .row.editing{background:#fafafa}
  .cell{display:flex;align-items:center;gap:8px;min-height:36px}
  .cell input, .cell textarea, .cell select{width:100%;padding:8px;border:1px solid var(--b);border-radius:8px}
  .cell textarea{min-height:38px;resize:vertical}
  .cell .img-prev{max-width:100%;max-height:44px;border-radius:6px;border:1px solid var(--b)}
  .actions{display:flex;gap:6px;flex-wrap:wrap}
  .icon-btn{border:1px solid var(--b);background:#fff;border-radius:8px;padding:8px;cursor:pointer}
  .muted{opacity:.7}
  .nowrap{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:420px}
  /* modal galerie */
  .modal{position:fixed;inset:0;background:rgba(0,0,0,.6);display:none;align-items:center;justify-content:center;padding:20px;z-index:999}
  .modal.show{display:flex}
  .modal .box{background:#fff;border-radius:12px;max-width:900px;width:100%;max-height:90vh;overflow:auto;padding:16px}
  .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px}
  .thumb{border:1px solid var(--b);border-radius:10px;padding:8px;display:flex;flex-direction:column;align-items:center;gap:8px;cursor:pointer;background:#fff}
  .thumb img{max-width:100%;max-height:100px;object-fit:contain}
  .thumb:hover{box-shadow:0 0 0 2px #1266f1}
</style>
<h2>Uploader une image</h2>
<div class="toolbar">
  <input type="file" id="file" accept="image/png,image/jpeg,image/webp">
  <button class="btn" id="upload">Envoyer</button>
</div>
<p class="muted">Les images sont disponibles sous <code>/data/images/</code><br>
Ex : <code>/data/images/point1.png</code> ou URL complète <code>https://votredomaine.ch/data/images/point1.png</code></p>

<!-- Modal galerie -->
<div id="modal" class="modal" role="dialog" aria-modal="true" aria-label="Choisir une image">
  <div class="box">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
      <strong>Choisir une image</strong>
      <button class="btn" id="closeModal">Fermer</button>
    </div>
    <div id="grid" class="grid"></div>
  </div>
</div>

<h1>Éditeur d’adresses</h1>
<div class="toolbar">
  <button class="btn" id="reload">Recharger</button>
  <button class="btn primary" id="add">+ Ajouter une adresse</button>
  <a href="/admin/logout.php" class="btn right">Se déconnecter</a>
</div>

<div class="list muted" style="display:grid;grid-template-columns:0.8fr 0.8fr 1.3fr 1.4fr auto;gap:12px 12px;margin-bottom:8px">
  <div>Latitude</div><div>Longitude</div><div>Image (URL / liste / galerie)</div><div>Commentaire (com)</div><div>Actions</div>
</div>

<div id="list" class="list" aria-live="polite"></div>
<div id="msg" class="msg"></div>


<script>
const csrf = <?= json_encode($csrf) ?>;
const listEl = document.getElementById('list');
const msgEl  = document.getElementById('msg');
const modal  = document.getElementById('modal');
const gridEl = document.getElementById('grid');
let data = [];        // [{lat, lng, image, com}, …]
let images = [];      // [{name, path, url}, …]
let editingIndex = -1;
let focusedImageInput = null; // référence de l'input image actuellement en édition

function setMsg(t){ msgEl.textContent = t || ''; }

async function load() {
  setMsg('Chargement…');
  const [rData, rImgs] = await Promise.all([
    fetch('api.php', {cache:'no-store'}),
    fetch('list_images.php', {cache:'no-store'})
  ]);
  if (!rData.ok) { setMsg('Erreur de chargement des adresses ❌'); return; }
  try { data = JSON.parse(await rData.text()); } catch { data = []; }
  images = rImgs.ok ? await rImgs.json() : [];
  render();
  setMsg('Chargé ✅');
}

function refreshImages() {
  // recharger la liste après upload
  fetch('list_images.php', {cache:'no-store'}).then(async r => {
    images = r.ok ? await r.json() : [];
  });
}

function saveAll() {
  return fetch('api.php', {
    method:'POST',
    headers:{'Content-Type':'application/json','X-CSRF': csrf},
    body: JSON.stringify(data)
  });
}

function toAbs(path){
  if (!path) return '';
  if (path.startsWith('http')) return path;
  const origin = window.location.origin;
  return path.startsWith('/') ? origin + path : origin + '/' + path;
}

function openGallery(forInput){
  focusedImageInput = forInput;
  gridEl.innerHTML = '';
  if (!images || images.length === 0) {
    gridEl.innerHTML = '<div class="muted">Aucune image.</div>';
  } else {
    images.forEach(img => {
      const d = document.createElement('div');
      d.className = 'thumb';
      d.innerHTML = `
        <img src="${img.url}" alt="">
        <div class="muted" style="font-size:12px">${img.name}</div>
      `;
      d.onclick = () => {
        if (focusedImageInput) {
          focusedImageInput.value = img.path; // on stocke le chemin relatif
          // déclenche un input event pour que la prévisu se mette à jour si besoin
          focusedImageInput.dispatchEvent(new Event('input', {bubbles:true}));
        }
        modal.classList.remove('show');
      }
      gridEl.appendChild(d);
    });
  }
  modal.classList.add('show');
}

document.getElementById('closeModal').onclick = () => modal.classList.remove('show');

function render(){
  listEl.innerHTML = '';
  if (!Array.isArray(data) || data.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'muted';
    empty.textContent = 'Aucune adresse pour le moment.';
    listEl.appendChild(empty);
    return;
  }

  data.forEach((item, i) => {
    const row = document.createElement('div');
    row.className = 'row' + (editingIndex===i?' editing':'');
    row.dataset.index = i;

    const imgAbs = toAbs(item.image||'');

    if (editingIndex === i) {
      // mode édition
      row.innerHTML = `
        <div class="cell"><input type="number" step="any" value="${item.lat ?? ''}" placeholder="Latitude"></div>
        <div class="cell"><input type="number" step="any" value="${item.lng ?? ''}" placeholder="Longitude"></div>
        <div class="cell">
          <div style="display:flex;gap:8px;flex:1">
            <input type="text" class="img-input" value="${item.image ?? ''}" placeholder="/data/images/xxx.png ou URL complète (laisser vide = sans image)">
            <select class="img-select" title="Images uploadées">
              <option value="">— choisir une image upload —</option>
              ${images.map(im => `<option value="${im.path}">${im.name}</option>`).join('')}
            </select>
            <button class="btn" data-act="gallery" title="Ouvrir la galerie">Galerie</button>
          </div>
        </div>
        <div class="cell"><textarea placeholder="Commentaire (optionnel)">${item.com ?? ''}</textarea></div>
        <div class="actions">
          <button class="icon-btn" title="Annuler" data-act="cancel">❎</button>
          <button class="icon-btn" title="Enregistrer" data-act="save">💾</button>
        </div>
      `;

      // wiring sélecteur et galerie
      const imgInput = row.querySelector('.img-input');
      const imgSelect = row.querySelector('.img-select');
      const galBtn    = row.querySelector('[data-act="gallery"]');

      imgSelect.onchange = () => { if (imgSelect.value) imgInput.value = imgSelect.value; };
      galBtn.onclick = (ev) => { ev.preventDefault(); openGallery(imgInput); };

    } else {
      // mode lecture
      row.innerHTML = `
        <div class="cell"><strong>${Number(item.lat).toFixed(6)}</strong></div>
        <div class="cell">${Number(item.lng).toFixed(6)}</div>
        <div class="cell">
          ${item.image ? `<img class="img-prev" src="${imgAbs}" alt="">` : '<span class="muted">—</span>'}
          <span class="muted nowrap">${item.image || ''}</span>
        </div>
        <div class="cell"><span class="nowrap">${(item.com || '') || '<span class="muted">—</span>'}</span></div>
        <div class="actions">
          <button class="icon-btn" title="Télécharger l’image" data-act="dl" ${item.image ? '' : 'disabled'}>⬇️</button>
          <button class="icon-btn" title="Copier l’URL de l’image" data-act="copy" ${item.image ? '' : 'disabled'}>🔗</button>
          <button class="icon-btn" title="Modifier" data-act="edit">✏️</button>
          <button class="icon-btn" title="Supprimer" data-act="del">🗑️</button>
        </div>
      `;
    }

    row.addEventListener('click', (e) => {
      const btn = e.target.closest('button');
      const act = btn?.dataset?.act;
      if (!act) return;

      if (act === 'edit') { editingIndex = i; render(); }
      if (act === 'cancel') { editingIndex = -1; render(); }

      if (act === 'save') {
        const [latIn, lngIn] = row.querySelectorAll('input[type="number"]');
        const imgIn = row.querySelector('.img-input');
        const comIn = row.querySelector('textarea');
        const lat = parseFloat(latIn.value);
        const lng = parseFloat(lngIn.value);
        if (Number.isNaN(lat) || Number.isNaN(lng)) { setMsg('Latitude/Longitude invalides'); return; }
        data[i] = { lat, lng, image: (imgIn.value||'').trim(), com: (comIn.value||'').trim() };
        setMsg('Enregistrement…');
        saveAll().then(r => {
          setMsg(r.ok ? 'Sauvegardé ✅' : 'Erreur ❌');
          editingIndex = -1; render();
        });
      }

      if (act === 'del') {
        if (!confirm('Supprimer cette adresse ?')) return;
        data.splice(i,1);
        setMsg('Enregistrement…');
        saveAll().then(r => { setMsg(r.ok ? 'Supprimé ✅' : 'Erreur ❌'); render(); });
      }

      if (act === 'dl') {
        const path = (data[i].image || '').trim();
        if (!path) { setMsg('Aucune image'); return; }
        if (path.startsWith('http')) window.open(path, '_blank');
        else window.open('download.php?file=' + encodeURIComponent(path), '_blank');
      }

      if (act === 'copy') {
        const path = (data[i].image || '').trim();
        if (!path) { setMsg('Aucune image'); return; }
        const url = toAbs(path);
        navigator.clipboard.writeText(url).then(
          ()=> setMsg('URL copiée ✅'),
          ()=> setMsg('Impossible de copier ❌')
        );
      }
    });

    listEl.appendChild(row);
  });
}

document.getElementById('add').onclick = () => {
  data.unshift({ lat: 0, lng: 0, image: '', com: '' });
  editingIndex = 0;
  render();
};

document.getElementById('reload').onclick = load;

document.getElementById('upload').onclick = async () => {
  const f = document.getElementById('file').files[0];
  if (!f) { setMsg('Choisis un fichier'); return; }
  const fd = new FormData(); fd.append('file', f);
  setMsg('Upload…');
  const r = await fetch('upload.php', { method:'POST', body: fd, headers:{'X-CSRF': csrf}});
  const j = await r.json();
  setMsg(r.ok ? ('Upload OK : '+j.url) : ('Erreur upload : '+(j.error||'')));
  if (r.ok) refreshImages(); // met à jour la liste des images disponibles
};

load();
</script>
</html>
