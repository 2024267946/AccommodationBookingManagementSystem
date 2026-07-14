(function () {
    const carouselSelector = '[data-accommodation-carousel], [data-carousel]';

    function slidesFor(carousel) {
        return Array.prototype.slice.call(carousel.querySelectorAll('img'));
    }

    function show(carousel, requestedIndex) {
        const slides = slidesFor(carousel);
        if (!slides.length) return;
        const index = (requestedIndex + slides.length) % slides.length;
        carousel.setAttribute('data-current-slide', String(index));
        slides.forEach(function (slide, position) {
            slide.classList.toggle('is-active', position === index);
        });
        const count = carousel.querySelector('.photo-count span, .carousel-count span');
        if (count) count.textContent = String(index + 1);
    }

    document.querySelectorAll(carouselSelector).forEach(function (carousel) {
        carousel.setAttribute('data-current-slide', '0');
        const slides = slidesFor(carousel);
        slides.forEach(function (slide) {
            slide.addEventListener('error', function () {
                const fallback = carousel.getAttribute('data-fallback');
                if (fallback && slide.getAttribute('src') !== fallback) slide.setAttribute('src', fallback);
            });
        });
        show(carousel, 0);
    });

    document.addEventListener('click', function (event) {
        const control = event.target.closest(
                '.photo-prev, .photo-next, .carousel-control.previous, .carousel-control.next');
        if (!control) return;
        const carousel = control.closest(carouselSelector);
        if (!carousel) return;
        event.preventDefault();
        event.stopPropagation();
        const current = parseInt(carousel.getAttribute('data-current-slide') || '0', 10);
        const backwards = control.classList.contains('photo-prev')
                || control.classList.contains('previous');
        show(carousel, current + (backwards ? -1 : 1));
    });
})();

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
