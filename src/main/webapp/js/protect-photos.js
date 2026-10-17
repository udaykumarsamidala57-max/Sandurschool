/* =========================================================
   PHOTO PROTECTION (light)
   Blocks right-click, long-press and dragging on photos so
   "Save image as" does not appear. Screenshots cannot be
   blocked by any website.
   ========================================================= */
(function () {
    var PHOTO = 'img, picture, svg image, .hero-slide, .d3-card, .distinct-card, .house-card, ' +
                '.latest-news-image, .ce-card, .desc-image-wrapper, .person-details-image';

    function onPhoto(e) {
        var t = e.target;
        return t && t.closest && t.closest(PHOTO);
    }

    document.addEventListener('contextmenu', function (e) {
        if (onPhoto(e)) e.preventDefault();
    }, true);

    document.addEventListener('dragstart', function (e) {
        if (onPhoto(e)) e.preventDefault();
    }, true);
})();
