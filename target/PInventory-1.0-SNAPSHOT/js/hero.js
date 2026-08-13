/**
 * HERO SECTION
 * Dynamic Hero Slider
 */

(function () {

    "use strict";

    const heroTimers = {};

    /**
     * Get slides
     */
    function getSlides(container) {
        return container.querySelectorAll(".hero-slide");
    }

    /**
     * Show slide
     */
    function showHeroSlide(container, index) {

        if (!container) return;

        const slides = getSlides(container);
        const dots = container.querySelectorAll(".dot");

        if (slides.length === 0) return;

        // Normalize index
        if (index >= slides.length) {
            index = 0;
        }

        if (index < 0) {
            index = slides.length - 1;
        }

        slides.forEach(function (slide, i) {

            slide.classList.toggle(
                "active",
                i === index
            );

        });

        dots.forEach(function (dot, i) {

            dot.classList.toggle(
                "active",
                i === index
            );

        });

    }


    /**
     * Next slide
     */
    function nextHeroSlide(containerId) {

        const container =
            document.getElementById(containerId);

        if (!container) return;

        const slides =
            getSlides(container);

        if (slides.length <= 1) return;

        let currentIndex = 0;

        slides.forEach(function (slide, index) {

            if (slide.classList.contains("active")) {
                currentIndex = index;
            }

        });

        showHeroSlide(
            container,
            currentIndex + 1
        );

    }


    /**
     * Start autoplay
     */
    function startHeroAutoplay(containerId) {

        const container =
            document.getElementById(containerId);

        if (!container) return;

        const slides =
            getSlides(container);

        if (slides.length <= 1) return;

        stopHeroAutoplay(containerId);

        const interval =
            parseInt(
                container.getAttribute("data-interval"),
                10
            ) || 4000;

        heroTimers[containerId] =
            setInterval(function () {

                nextHeroSlide(containerId);

            }, interval);

    }


    /**
     * Stop autoplay
     */
    function stopHeroAutoplay(containerId) {

        if (heroTimers[containerId]) {

            clearInterval(
                heroTimers[containerId]
            );

            delete heroTimers[containerId];

        }

    }


    /**
     * Manual previous / next
     */
    window.manualHeroSlide =
        function (containerId, step) {

            const container =
                document.getElementById(containerId);

            if (!container) return;

            const slides =
                getSlides(container);

            if (slides.length <= 1) return;

            let currentIndex = 0;

            slides.forEach(function (slide, index) {

                if (slide.classList.contains("active")) {
                    currentIndex = index;
                }

            });

            showHeroSlide(
                container,
                currentIndex + step
            );

            startHeroAutoplay(containerId);

        };


    /**
     * Go directly to slide
     */
    window.goToHeroSlide =
        function (containerId, index) {

            const container =
                document.getElementById(containerId);

            if (!container) return;

            showHeroSlide(
                container,
                index
            );

            startHeroAutoplay(containerId);

        };


    /**
     * Initialize all hero sections
     */
    document.addEventListener(
        "DOMContentLoaded",
        function () {

            const heroes =
                document.querySelectorAll(
                    ".hero-fullscreen-container"
                );

            heroes.forEach(function (hero) {

                if (!hero.id) return;

                const slides =
                    getSlides(hero);

                if (slides.length === 0) return;

                // Make first slide active
                showHeroSlide(hero, 0);

                // Start autoplay
                if (
                    hero.getAttribute("data-autoplay")
                    === "true"
                ) {

                    startHeroAutoplay(
                        hero.id
                    );

                }

                // Pause when mouse enters
                hero.addEventListener(
                    "mouseenter",
                    function () {

                        stopHeroAutoplay(
                            hero.id
                        );

                    }
                );

                // Resume when mouse leaves
                hero.addEventListener(
                    "mouseleave",
                    function () {

                        if (
                            hero.getAttribute(
                                "data-autoplay"
                            ) === "true"
                        ) {

                            startHeroAutoplay(
                                hero.id
                            );

                        }

                    }
                );

            });

        }
    );

})();