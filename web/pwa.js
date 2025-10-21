(() => {
  window.pwaInstalled = false;
  window.__deferredPWAInstallPrompt = null;

  // 📦 بررسی از localStorage
  const stored = localStorage.getItem('pwa_installed') === 'true';
  if (stored) {
    window.pwaInstalled = true;
    console.log('[PWA] Detected installed state from localStorage');
  }

  // 📦 اگر اپ در حالت standalone اجرا می‌شود
  if (window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone) {
    window.pwaInstalled = true;
    localStorage.setItem('pwa_installed', 'true');
    console.log('[PWA] Running as standalone');
  }

  // 📱 زمانی که مرورگر event نصب را ارسال می‌کند
  window.addEventListener('appinstalled', () => {
    window.pwaInstalled = true;
    localStorage.setItem('pwa_installed', 'true'); // ✅ ذخیره دائمی
    window.__deferredPWAInstallPrompt = null;
    console.log('[PWA] App installed event fired');
  });

  // 💡 گرفتن event نصب
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    window.__deferredPWAInstallPrompt = e;
    console.log('[PWA] beforeinstallprompt captured');
  });

  // 🧠 بررسی اینکه آیا قابل نصب است؟
  window.isInstallablePWA = function () {
    return !!window.__deferredPWAInstallPrompt;
  };

  // ⚡ اجرای نصب
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
      localStorage.setItem('pwa_installed', 'true'); // ✅ همین‌جا هم
    }
    return choice;
  };

  // Debug
  window.addEventListener('load', () => {
    console.log('[PWA] pwaInstalled =', window.pwaInstalled);
  });
})();
