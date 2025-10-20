// web/pwa.js

window.pwaInstalled = false;

// بررسی حالت standalone در زمان لود
if (window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone) {
  window.pwaInstalled = true;
}

// وقتی نصب انجام شد (در هر مرورگر)
window.addEventListener('appinstalled', () => {
  window.pwaInstalled = true;
  console.log('[PWA] App installed event fired');
});

// برای debug
window.addEventListener('load', () => {
  console.log('[PWA] pwaInstalled =', window.pwaInstalled);
});
