// Animation Configuration
const config = {
    // Particle settings
    particleCount: 150,
    minSize: 18,
    maxSize: 38,
    minSpeed: 0.5,
    maxSpeed: 2.5,
    
    // Mouse interaction
    mouseForce: 1000,
    mouseRadius: 100,
    
    // Font settings
    fonts: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    fontFamilies: ['Roboto', 'Arial', 'Helvetica', 'Times New Roman', 'Courier New'],
    
    // Colors
    colors: ['#111827', '#374151', '#4B5563', '#6B7280', '#9CA3AF'],
    
    // Animation smoothness
    fps: 60
};

class Particle {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.reset();
    }

    reset() {
        // Position
        this.x = Math.random() * this.canvas.width;
        this.y = Math.random() * this.canvas.height;
        
        // Velocity
        const speed = config.minSpeed + Math.random() * (config.maxSpeed - config.minSpeed);
        const angle = Math.random() * Math.PI * 2;
        this.vx = Math.cos(angle) * speed;
        this.vy = Math.sin(angle) * speed;
        
        // Appearance
        this.size = config.minSize + Math.random() * (config.maxSize - config.minSize);
        this.char = config.fonts[Math.floor(Math.random() * config.fonts.length)];
        this.font = `${this.size}px ${config.fontFamilies[Math.floor(Math.random() * config.fontFamilies.length)]}`;
        this.color = config.colors[Math.floor(Math.random() * config.colors.length)];
        
        // Rotation
        this.rotation = Math.random() * Math.PI * 2;
        this.rotationSpeed = (Math.random() - 0.5) * 0.02;
    }

    update(mouseX, mouseY) {
        // Update position
        this.x += this.vx;
        this.y += this.vy;
        
        // Mouse interaction
        if (mouseX !== null && mouseY !== null) {
            const dx = mouseX - this.x;
            const dy = mouseY - this.y;
            const distance = Math.sqrt(dx * dx + dy * dy);
            
            if (distance < config.mouseRadius) {
                const force = (config.mouseRadius - distance) / config.mouseRadius;
                const angle = Math.atan2(dy, dx);
                this.vx -= Math.cos(angle) * force * config.mouseForce / 10000;
                this.vy -= Math.sin(angle) * force * config.mouseForce / 10000;
            }
        }
        
        // Update rotation
        this.rotation += this.rotationSpeed;
        
        // Boundary check
        if (this.x < -50) this.x = this.canvas.width + 50;
        if (this.x > this.canvas.width + 50) this.x = -50;
        if (this.y < -50) this.y = this.canvas.height + 50;
        if (this.y > this.canvas.height + 50) this.y = -50;
    }

    draw() {
        this.ctx.save();
        this.ctx.translate(this.x, this.y);
        this.ctx.rotate(this.rotation);
        this.ctx.font = this.font;
        this.ctx.fillStyle = this.color;
        this.ctx.fillText(this.char, -this.size/2, this.size/2);
        this.ctx.restore();
    }
}

class FontAnimation {
    constructor() {
        this.canvas = document.getElementById('fontAnimation');
        if (!this.canvas) {
            console.error('Canvas element not found!');
            return;
        }
        
        this.ctx = this.canvas.getContext('2d');
        if (!this.ctx) {
            console.error('Could not get canvas context!');
            return;
        }
        
        this.particles = [];
        this.mouseX = null;
        this.mouseY = null;
        
        console.log('FontAnimation initialized');
        this.init();
    }

    init() {
        // Set canvas size
        this.resize();
        console.log('Canvas size:', this.canvas.width, 'x', this.canvas.height);
        
        // Create particles
        for (let i = 0; i < config.particleCount; i++) {
            this.particles.push(new Particle(this.canvas));
        }
        console.log('Created', this.particles.length, 'particles');
        
        // Event listeners
        window.addEventListener('resize', () => this.resize());
        this.canvas.parentElement.addEventListener('mousemove', (e) => this.handleMouseMove(e));
        this.canvas.parentElement.addEventListener('mouseleave', () => this.handleMouseLeave());
        
        // Start animation
        this.animate();
        console.log('Animation started');
    }

    resize() {
        const rect = this.canvas.parentElement.getBoundingClientRect();
        this.canvas.width = rect.width;
        this.canvas.height = rect.height;
        console.log('Resized canvas to:', rect.width, 'x', rect.height);
    }

    handleMouseMove(e) {
        const rect = this.canvas.getBoundingClientRect();
        this.mouseX = e.clientX - rect.left;
        this.mouseY = e.clientY - rect.top;
    }

    handleMouseLeave() {
        this.mouseX = null;
        this.mouseY = null;
    }

    animate() {
        // Clear canvas
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Update and draw particles
        this.particles.forEach(particle => {
            particle.update(this.mouseX, this.mouseY);
            particle.draw();
        });
        
        // Request next frame
        requestAnimationFrame(() => this.animate());
    }
}

// Initialize animation when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM loaded, initializing animation...');
    new FontAnimation();
}); 