document.querySelectorAll('[data-accommodation-carousel]').forEach(function (carousel) {
    const slides = Array.from(carousel.querySelectorAll('img'));
    if (!slides.length) return;
    slides.forEach((slide, index) => slide.classList.toggle('is-active', index === 0));
    if (slides.length < 2) return;
    let current = 0;
    const count = carousel.querySelector('.photo-count span');
    function show(index) {
        current = (index + slides.length) % slides.length;
        slides.forEach((slide, position) => slide.classList.toggle('is-active', position === current));
        if (count) count.textContent = current + 1;
    }
    const previous = carousel.querySelector('.photo-prev');
    const next = carousel.querySelector('.photo-next');
    if (previous) previous.addEventListener('click', function (event) {
        event.preventDefault(); event.stopPropagation(); show(current - 1);
    });
    if (next) next.addEventListener('click', function (event) {
        event.preventDefault(); event.stopPropagation(); show(current + 1);
    });
});
