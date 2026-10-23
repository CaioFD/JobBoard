// Favorite job
document.querySelectorAll('.bookmark').forEach(btn => {
  btn.addEventListener('click', () => {
    btn.setAttribute('aria-pressed', btn.getAttribute('aria-pressed') !== 'true');
  });
});

// Header fica preto ao rolar, senão o menu branco some sobre a lista de vagas
const header = document.querySelector('header');
window.addEventListener('scroll', () => header.classList.toggle('scrolled', scrollY > 0));
