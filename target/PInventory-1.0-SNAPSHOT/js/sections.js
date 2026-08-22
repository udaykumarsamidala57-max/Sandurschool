/**
 * Dynamic Section & Hero Carousel Manager
 */

// Global registry for autoplay intervals keyed by container ID
const autoPlayTimers = {};

/**
 * Updates CSS classes on slides and navigation dots.
 */
function showSlide(container, index) {
    if (!container) return;

    const slides = container.querySelectorAll('.hero-slide');
    const dots = container.querySelectorAll('.dot');
    
    if (slides.length === 0) return;

    // Normalize index bounds just in case
    const targetIndex = (index + slides.length) % slides.length;

    slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === targetIndex);
    });

    dots.forEach((dot, i) => {
        dot.classList.toggle('active', i === targetIndex);
    });
}

/**
 * Advances to the next slide in sequence.
 */
function nextSlide(containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    const slides = container.querySelectorAll('.hero-slide');
    if (slides.length === 0) return;

    const currentIndex = Array.from(slides).findIndex(slide => slide.classList.contains('active'));
    const newIndex = currentIndex === -1 ? 0 : (currentIndex + 1) % slides.length;

    showSlide(container, newIndex);
}

/**
 * Allows manual navigation forward/backward (+1 / -1) and resets timer.
 */
function manualChangeSlide(containerId, step) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    const slides = container.querySelectorAll('.hero-slide');
    if (slides.length === 0) return;

    const currentIndex = Array.from(slides).findIndex(slide => slide.classList.contains('active'));
    let newIndex = (currentIndex === -1 ? 0 : currentIndex) + step;

    if (newIndex >= slides.length) newIndex = 0;
    if (newIndex < 0) newIndex = slides.length - 1;

    showSlide(container, newIndex);
    resetAutoplay(containerId);
}

/**
 * Jumps directly to a target slide index and resets timer.
 */
function manualGoToSlide(containerId, index) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    showSlide(container, index);
    resetAutoplay(containerId);
}

/**
 * Starts automatic slide rotation for a given container ID.
 */
function startAutoplay(containerId, interval) {
    // Clear any pre-existing timer to prevent duplicate intervals
    stopAutoplay(containerId);

    autoPlayTimers[containerId] = setInterval(() => {
        nextSlide(containerId);
    }, interval || 4000);
}

/**
 * Stops standard interval rotation.
 */
function stopAutoplay(containerId) {
    if (autoPlayTimers[containerId]) {
        clearInterval(autoPlayTimers[containerId]);
        delete autoPlayTimers[containerId];
    }
}

/**
 * Resets existing autoplay timer back to zero.
 */
function resetAutoplay(containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    const interval = parseInt(container.getAttribute('data-interval'), 10) || 4000;
    startAutoplay(containerId, interval);
}

/**
 * Modal visibility helper.
 */
function closePopupModal(modalId) {
    const modalElement = document.getElementById(modalId);
    if (modalElement) {
        modalElement.style.display = 'none';
    }
}

// Auto-initialize slideshow containers when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll('.hero-fullscreen-container[data-autoplay="true"]').forEach(container => {
        if (!container.id) return;

        const interval = parseInt(container.getAttribute('data-interval'), 10) || 4000;
        startAutoplay(container.id, interval);

        // Pause autoplay on mouse hover for enhanced user accessibility
        container.addEventListener('mouseenter', () => stopAutoplay(container.id));
        container.addEventListener('mouseleave', () => startAutoplay(container.id, interval));
    });
});