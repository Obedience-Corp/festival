// GIFs autoplay in view. Pausing shows the poster; playing restarts the recording.
// Starting from the poster also keeps the no-JS and reduced-motion paths still.
(() => {
  const motion = window.matchMedia('(prefers-reduced-motion: reduce)');

  document.querySelectorAll('[data-demo-src]').forEach((recording) => {
    const img = recording.querySelector('img');
    const button = recording.querySelector('[data-demo-toggle]');
    let wantsPlayback = !motion.matches;
    let inView = !('IntersectionObserver' in window);
    let failed = false;

    function render() {
      const playing = wantsPlayback && inView && !document.hidden && !failed;
      const src = playing ? recording.dataset.demoSrc : recording.dataset.demoPoster;
      if (img.getAttribute('src') !== src) img.setAttribute('src', src);
      button.textContent = failed ? 'Animation unavailable' : playing ? 'Pause animation' : 'Play animation';
      button.setAttribute('aria-label', `${button.textContent}: ${recording.dataset.demoTitle}`);
      button.disabled = failed;
    }

    button.hidden = false;
    button.addEventListener('click', () => {
      wantsPlayback = !wantsPlayback;
      render();
    });
    img.addEventListener('error', () => {
      failed = true;
      render();
    });
    motion.addEventListener('change', () => {
      wantsPlayback = !motion.matches;
      render();
    });
    document.addEventListener('visibilitychange', render);

    if ('IntersectionObserver' in window) {
      const observer = new IntersectionObserver((entries) => {
        inView = entries[0].isIntersecting;
        render();
      });
      observer.observe(recording);
    }
    render();
  });
})();
