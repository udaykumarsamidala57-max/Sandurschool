/**
 * =========================================================
 * HERO SECTION MANAGER
 * =========================================================
 */

(function () {

    "use strict";


    /* =====================================================
       AUTOPLAY TIMERS
    ===================================================== */

    const heroTimers = {};


    /* =====================================================
       SHOW SLIDE
    ===================================================== */

    function showHeroSlide(container, index) {

        if (!container) {
            return;
        }


        const slides =
            container.querySelectorAll(".hero-slide");

        const dots =
            container.querySelectorAll(".dot");


        if (slides.length === 0) {
            return;
        }


        /* Normalize index */

        if (index >= slides.length) {
            index = 0;
        }

        if (index < 0) {
            index = slides.length - 1;
        }


        /* Update slides */

        slides.forEach(function (slide, i) {

            slide.classList.toggle(
                "active",
                i === index
            );

        });


        /* Update dots */

        dots.forEach(function (dot, i) {

            dot.classList.toggle(
                "active",
                i === index
            );

        });


        /* Store current index */

        container.dataset.currentSlide = index;

    }


    /* =====================================================
       NEXT SLIDE
    ===================================================== */

    function nextHeroSlide(containerId) {

        const container =
            document.getElementById(containerId);


        if (!container) {
            return;
        }


        const slides =
            container.querySelectorAll(".hero-slide");


        if (slides.length <= 1) {
            return;
        }


        let current =
            parseInt(
                container.dataset.currentSlide || "0",
                10
            );


        let next = current + 1;


        if (next >= slides.length) {
            next = 0;
        }


        showHeroSlide(container, next);

    }


    /* =====================================================
       MANUAL PREVIOUS / NEXT
    ===================================================== */

    window.manualHeroSlide = function (
        containerId,
        step
    ) {

        const container =
            document.getElementById(containerId);


        if (!container) {
            return;
        }


        const slides =
            container.querySelectorAll(".hero-slide");


        if (slides.length <= 1) {
            return;
        }


        let current =
            parseInt(
                container.dataset.currentSlide || "0",
                10
            );


        let newIndex =
            current + step;


        if (newIndex >= slides.length) {
            newIndex = 0;
        }


        if (newIndex < 0) {
            newIndex = slides.length - 1;
        }


        showHeroSlide(container, newIndex);


        resetHeroAutoplay(containerId);

    };


    /* =====================================================
       GO TO SPECIFIC SLIDE
    ===================================================== */

    window.goToHeroSlide = function (
        containerId,
        index
    ) {

        const container =
            document.getElementById(containerId);


        if (!container) {
            return;
        }


        showHeroSlide(container, index);


        resetHeroAutoplay(containerId);

    };


    /* =====================================================
       START AUTOPLAY
    ===================================================== */

    function startHeroAutoplay(
        containerId,
        interval
    ) {

        stopHeroAutoplay(containerId);


        heroTimers[containerId] =
            setInterval(function () {

                nextHeroSlide(containerId);

            }, interval);

    }


    /* =====================================================
       STOP AUTOPLAY
    ===================================================== */

    function stopHeroAutoplay(containerId) {

        if (heroTimers[containerId]) {

            clearInterval(
                heroTimers[containerId]
            );

            delete heroTimers[containerId];

        }

    }


    /* =====================================================
       RESET AUTOPLAY
    ===================================================== */

    function resetHeroAutoplay(containerId) {

        const container =
            document.getElementById(containerId);


        if (!container) {
            return;
        }


        const interval =
            parseInt(
                container.dataset.interval || "4000",
                10
            );


        startHeroAutoplay(
            containerId,
            interval
        );

    }


    /* =====================================================
       INITIALIZE ALL HERO SECTIONS
    ===================================================== */

    function initializeHeroes() {

        const heroes =
            document.querySelectorAll(
                ".hero-fullscreen-container"
            );


        heroes.forEach(function (hero) {

            const containerId =
                hero.id;


            if (!containerId) {
                return;
            }


            const slides =
                hero.querySelectorAll(
                    ".hero-slide"
                );


            if (slides.length === 0) {
                return;
            }


            /* First slide */

            showHeroSlide(hero, 0);


            /* Read interval */

            const interval =
                parseInt(
                    hero.dataset.interval || "4000",
                    10
                );


            /* Start autoplay only when enabled */

            if (
                hero.dataset.autoplay === "true"
                &&
                slides.length > 1
            ) {

                startHeroAutoplay(
                    containerId,
                    interval
                );

            }


            /* Pause on mouse enter */

            hero.addEventListener(
                "mouseenter",
                function () {

                    stopHeroAutoplay(
                        containerId
                    );

                }
            );


            /* Resume on mouse leave */

            hero.addEventListener(
                "mouseleave",
                function () {

                    if (
                        hero.dataset.autoplay === "true"
                        &&
                        slides.length > 1
                    ) {

                        startHeroAutoplay(
                            containerId,
                            interval
                        );

                    }

                }
            );

        });

    }


    /* =====================================================
       DOM READY
    ===================================================== */

    document.addEventListener(
        "DOMContentLoaded",
        initializeHeroes
    );


})();