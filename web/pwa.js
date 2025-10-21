// web/pwa.js

(() => {
  // ✅ متغیرهای سراسری در window
  window.pwaInstalled = false;
  window.__deferredPWAInstallPrompt = null;

  // 📦 وقتی اپ از قبل در حالت standalone اجرا می‌شود
  if (window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone) {
    window.pwaInstalled = true;
    console.log('[PWA] Already running as standalone');
  }

  // 📱 زمانی که مرورگر event نصب را ارسال می‌کند
  window.addEventListener('appinstalled', () => {
    window.pwaInstalled = true;
    window.__deferredPWAInstallPrompt = null;
    console.log('[PWA] App installed event fired');
  });

  // 💡 گرفتن event نصب
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    window.__deferredPWAInstallPrompt = e;
    console.log('[PWA] beforeinstallprompt captured');
  });

  // 🧠 متد برای بررسی اینکه آیا قابل نصب است؟
  window.isInstallablePWA = function () {
    return !!window.__deferredPWAInstallPrompt;
  };

  // ⚡ متد برای اجرای نصب
  window.promptInstallPWA = async function () {
    if (!window.__deferredPWAInstallPrompt) {
      console.log('[PWA] No install prompt available');
      return null;
    }
    const prompt = window.__deferredPWAInstallPrompt;
    window.__deferredPWAInstallPrompt = null;
    prompt.prompt();
    const choice = await prompt.userChoice;
    console.log('[PWA] User choice:', choice);
    if (choice.outcome === 'accepted') {
      window.pwaInstalled = true;
    }
    return choice;
  };

  // 🧩 برای debug
  window.addEventListener('load', () => {
    console.log('[PWA] pwaInstalled =', window.pwaInstalled);
  });
})();
