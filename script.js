// Copy functionality with enhanced feedback
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        const copyButton = event.target;
        const originalText = copyButton.textContent;
        copyButton.textContent = 'Copied!';
        copyButton.classList.add('bg-green-700');
        setTimeout(() => {
            copyButton.textContent = originalText;
            copyButton.classList.remove('bg-green-700');
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy text: ', err);
        const copyButton = event.target;
        const originalText = copyButton.textContent;
        copyButton.textContent = 'Failed to copy';
        copyButton.classList.add('bg-red-700');
        setTimeout(() => {
            copyButton.textContent = originalText;
            copyButton.classList.remove('bg-red-700');
        }, 2000);
    });
}

// Mobile menu functionality
document.addEventListener('DOMContentLoaded', () => {
    const mobileMenuButton = document.querySelector('[data-mobile-menu-button]');
    const closeMenuButton = document.querySelector('[data-close-menu-button]');
    const mobileMenu = document.querySelector('[data-mobile-menu]');
    const backdrop = document.querySelector('[data-backdrop]');

    function toggleMenu() {
        mobileMenu.classList.toggle('hidden');
        backdrop.classList.toggle('hidden');
        document.body.classList.toggle('overflow-hidden');
    }

    mobileMenuButton?.addEventListener('click', toggleMenu);
    closeMenuButton?.addEventListener('click', toggleMenu);
    backdrop?.addEventListener('click', toggleMenu);

    // Close menu when clicking on mobile menu links
    const mobileMenuLinks = mobileMenu?.querySelectorAll('a');
    mobileMenuLinks?.forEach(link => {
        link.addEventListener('click', toggleMenu);
    });
});

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');
        const targetElement = document.querySelector(targetId);
        
        if (targetElement) {
            targetElement.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Header scroll effect
let lastScrollTop = 0;
const header = document.querySelector('header');
const scrollThreshold = 50;

window.addEventListener('scroll', () => {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    
    if (scrollTop > scrollThreshold) {
        header.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
        header.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)';
    } else {
        header.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
        header.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.03)';
    }

    lastScrollTop = scrollTop;
}); 