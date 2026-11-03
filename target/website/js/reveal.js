/* =========================================================
   SCROLL ANIMATIONS for Distinct, Distinct3 (Mosaic), Latest News and Events.
   When a section scrolls into view, its cards fade and rise
   into place one after another. Runs once per section.
   Nothing is hidden unless this script runs, and visitors who
   ask their device for reduced motion see no animation.
   Styles: css/animations.css
   ========================================================= */
(function () {
    if (!('IntersectionObserver' in window)) return;
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    var groups = [
        ['.distinct-section',      '.distinct-intro, .distinct-card'],
        ['.d3-section',            '.d3-intro, .d3-card'],
        ['.latest-news-section',   '.latest-news-header, .latest-news-card'],
        ['.campus-events-section', '.section-header, .event-card']
    ];

    function start() {
        var io = new IntersectionObserver(function (entries) {
            entries.forEach(function (e) {
                if (e.isIntersecting) {
                    e.target.classList.add('anim-in');
                    io.unobserve(e.target);
                }
            });
        }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

        groups.forEach(function (g) {
            document.querySelectorAll(g[0]).forEach(function (section) {
                section.querySelectorAll(g[1]).forEach(function (el, i) {
                    el.classList.add('anim-item');
                    el.style.setProperty('--anim-i', Math.min(i, 8));
                });
                section.classList.add('anim-sec');
                io.observe(section);
            });
        });
        document.documentElement.classList.add('anim-ready');
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
