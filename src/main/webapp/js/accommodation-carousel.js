document.querySelectorAll('[data-accommodation-carousel], [data-carousel]').forEach(function (carousel) {
    const slides = Array.from(carousel.querySelectorAll('img'));
    if (!slides.length) return;
    slides.forEach(function (slide) {
        slide.addEventListener('error', function () {
            const fallback = carousel.dataset.fallback;
            if (fallback && slide.src !== new URL(fallback, window.location.href).href) {
                slide.src = fallback;
            }
        });
    });
    slides.forEach((slide, index) => slide.classList.toggle('is-active', index === 0));
    if (slides.length < 2) return;
    let current = 0;
    const count = carousel.querySelector('.photo-count span, .carousel-count span');
    function show(index) {
        current = (index + slides.length) % slides.length;
        slides.forEach((slide, position) => slide.classList.toggle('is-active', position === current));
        if (count) count.textContent = current + 1;
    }
    const previous = carousel.querySelector('.photo-prev, .carousel-control.previous');
    const next = carousel.querySelector('.photo-next, .carousel-control.next');
    if (previous) previous.addEventListener('click', function (event) {
        event.preventDefault(); event.stopPropagation(); show(current - 1);
    });
    if (next) next.addEventListener('click', function (event) {
        event.preventDefault(); event.stopPropagation(); show(current + 1);
    });
});

(function () {
    const pictures = document.querySelectorAll('.accom-photo-carousel img, .accommodation-carousel img');
    if (!pictures.length) return;
    const lightbox = document.createElement('div');
    lightbox.className = 'accommodation-lightbox';
    lightbox.hidden = true;
    lightbox.setAttribute('role', 'dialog');
    lightbox.setAttribute('aria-modal', 'true');
    lightbox.setAttribute('aria-label', 'Full-screen accommodation picture');
    lightbox.innerHTML = '<button type="button" class="accommodation-lightbox-close" aria-label="Close full-screen picture">&times;</button><img alt="">';
    document.body.appendChild(lightbox);
    const fullImage = lightbox.querySelector('img');
    function close() {
        lightbox.hidden = true;
        fullImage.removeAttribute('src');
        document.body.style.overflow = '';
    }
    pictures.forEach(function (picture) {
        picture.setAttribute('tabindex', '0');
        function open(event) {
            event.preventDefault();
            event.stopPropagation();
            fullImage.src = picture.currentSrc || picture.src;
            fullImage.alt = picture.alt || 'Accommodation picture';
            lightbox.hidden = false;
            document.body.style.overflow = 'hidden';
            lightbox.querySelector('.accommodation-lightbox-close').focus();
        }
        picture.addEventListener('click', open);
        picture.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') open(event);
        });
    });
    lightbox.querySelector('.accommodation-lightbox-close').addEventListener('click', close);
    lightbox.addEventListener('click', function (event) {
        if (event.target === lightbox) close();
    });
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && !lightbox.hidden) close();
    });
})();
