/* =========================================================
   PHOTO PROTECTION
   - Right-click, long-press and dragging on photos are blocked,
     so "Save image as" does not appear.
   - When someone tries to save (right-click / long-press on a photo),
     presses Print Screen, a screenshot shortcut or Ctrl+S, or prints
     the page, a big diagonal "SANDUR RESIDENTIAL SCHOOL" watermark
     covers the photos for a few seconds.
   Note: no website can detect a phone's own screenshot buttons.
   ========================================================= */
(function () {
    var PHOTO = 'img, picture, .hero-slide, .d3-card, .distinct-card, .house-card, ' +
                '.latest-news-image, .ce-card, .desc-image-wrapper, .person-details-image';
    var TEXT = 'SANDUR RESIDENTIAL SCHOOL';
    var SHOW_MS = 3500;
    var MIN_SIZE = 80;           // ignore icons and small logos

    // ---------- styles for the watermark layer ----------
    var css = document.createElement('style');
    css.textContent =
        '.srs-wm{position:absolute;z-index:2147483000;pointer-events:none;overflow:hidden;' +
        'opacity:0;transition:opacity .15s ease}' +
        '.srs-wm.on{opacity:1}' +
        '.srs-wm svg{display:block;width:100%;height:100%}' +
        '@media print{.srs-wm{opacity:1 !important}}';
    document.head.appendChild(css);

    var layers = [];
    var hideTimer = null;

    function photoOf(target) {
        if (!target || !target.closest) return null;
        var box = target.closest(PHOTO);
        if (!box) return null;
        if (box.tagName === 'IMG') return box;
        var img = box.querySelector('img');
        return img && img.offsetWidth >= MIN_SIZE ? img : box;
    }

    function svgFor(w, h) {
        var angle = -Math.atan2(h, w) * 180 / Math.PI;
        var diag = Math.sqrt(w * w + h * h);
        var size = Math.max(14, Math.min(diag / 13, 110));
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ' + w + ' ' + h + '">' +
            '<rect width="100%" height="100%" fill="rgba(59,22,3,0.18)"/>' +
            '<text x="50%" y="50%" text-anchor="middle" dominant-baseline="middle" ' +
            'transform="rotate(' + angle + ' ' + (w / 2) + ' ' + (h / 2) + ')" ' +
            'textLength="' + (diag * 0.86) + '" lengthAdjust="spacingAndGlyphs" ' +
            'font-family="Georgia, serif" font-weight="700" font-size="' + size + '" ' +
            'fill="rgba(255,255,255,0.78)" stroke="rgba(59,22,3,0.75)" stroke-width="' + Math.max(1, size / 22) + '">' +
            TEXT + '</text></svg>';
    }

    function cover(el) {
        var r = el.getBoundingClientRect();
        if (r.width < MIN_SIZE || r.height < MIN_SIZE) return;
        if (r.bottom < 0 || r.top > window.innerHeight || r.right < 0 || r.left > window.innerWidth) return;
        var d = document.createElement('div');
        d.className = 'srs-wm';
        d.style.left = (r.left + window.pageXOffset) + 'px';
        d.style.top = (r.top + window.pageYOffset) + 'px';
        d.style.width = r.width + 'px';
        d.style.height = r.height + 'px';
        d.innerHTML = svgFor(Math.round(r.width), Math.round(r.height));
        document.body.appendChild(d);
        layers.push(d);
        requestAnimationFrame(function () { d.classList.add('on'); });
    }

    function clear() {
        layers.forEach(function (d) { if (d.parentNode) d.parentNode.removeChild(d); });
        layers = [];
    }

    function show(elements, ms) {
        clearTimeout(hideTimer);
        clear();
        elements.forEach(cover);
        if (ms) hideTimer = setTimeout(clear, ms);
    }

    function allPhotos() {
        return Array.prototype.slice.call(document.querySelectorAll('img'))
            .filter(function (i) { return i.offsetWidth >= MIN_SIZE && i.offsetHeight >= MIN_SIZE; });
    }

    // ---------- right-click (computer) and long-press (Android) ----------
    document.addEventListener('contextmenu', function (e) {
        var p = photoOf(e.target);
        if (!p) return;
        e.preventDefault();
        show([p], SHOW_MS);
    }, true);

    // ---------- long-press on iPhone (no contextmenu event there) ----------
    var pressTimer = null;
    document.addEventListener('touchstart', function (e) {
        var p = photoOf(e.target);
        if (!p) return;
        clearTimeout(pressTimer);
        pressTimer = setTimeout(function () { show([p], SHOW_MS); }, 450);
    }, { passive: true, capture: true });
    ['touchend', 'touchmove', 'touchcancel'].forEach(function (ev) {
        document.addEventListener(ev, function () { clearTimeout(pressTimer); }, { passive: true, capture: true });
    });

    // ---------- dragging a photo out ----------
    document.addEventListener('dragstart', function (e) {
        if (photoOf(e.target)) e.preventDefault();
    }, true);

    // ---------- Print Screen / screenshot shortcuts / Ctrl+S ----------
    document.addEventListener('keydown', function (e) {
        var k = e.key || '';
        var macShot = e.metaKey && e.shiftKey && (k === '3' || k === '4' || k === '5');
        var winSnip = e.shiftKey && e.metaKey && (k === 'S' || k === 's');
        var saveKey = (e.ctrlKey || e.metaKey) && !e.shiftKey && (k === 's' || k === 'S');
        if (k === 'PrintScreen' || macShot || winSnip) {
            show(allPhotos(), SHOW_MS);
        }
        if (saveKey) {
            e.preventDefault();
            show(allPhotos(), SHOW_MS);
        }
    }, true);
    document.addEventListener('keyup', function (e) {
        if (e.key === 'PrintScreen') show(allPhotos(), SHOW_MS);
    }, true);

    // ---------- printing the page ----------
    window.addEventListener('beforeprint', function () { show(allPhotos(), 0); });
    window.addEventListener('afterprint', clear);

    // layers are placed for the current layout; drop them if it changes
    window.addEventListener('resize', clear);
})();
