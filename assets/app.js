import { themeChange } from 'theme-change'

themeChange()

window.onload = () => {
  var themes = document.querySelectorAll('.theme-change__option');
  let currentTheme = localStorage.getItem('theme');
  
  document.body.setAttribute('data-theme', currentTheme)

  let themeEvent = (e, i) => {
    localStorage.setItem('theme', e.target.dataset.theme);
    document.body.setAttribute('data-theme', e.target.dataset.theme)
  }
  themes.forEach((item) => {
      item.addEventListener('click', themeEvent)
  });

  window.addEventListener('click', function(e) {
    document.querySelectorAll('.dropdown').forEach(function(dropdown) {
      if (!dropdown.contains(e.target)) {
        dropdown.open = false;
      }
    });
  });
};

