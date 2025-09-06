# ABR³Havens Deployment Guide

## Project Overview

This Astro project has been optimized following Astro best practices and is ready for deployment. The application includes:

- ✅ Proper layout structure with BaseLayout
- ✅ SEO optimization with meta tags and sitemap
- ✅ 404 error page
- ✅ Component-based architecture with working carousel and lightbox
- ✅ Optimized images with Astro's Image component
- ✅ TypeScript support
- ✅ Tailwind CSS for styling
- ✅ Performance optimizations
- ✅ Interactive features (image carousels with auto-advance, lightbox modal)

## Build Process

The project builds successfully with:
```bash
pnpm build
```

This generates a static site in the `dist/` directory with:
- Optimized images (WebP format)
- Minified CSS and JavaScript
- Generated sitemap
- Static HTML pages

## cPanel Deployment (Your Setup)

Since you're hosting via cPanel, follow these steps:

### 1. Build the Project
```bash
pnpm build
```

### 2. Upload to cPanel
1. Open your cPanel File Manager
2. Navigate to your domain's public_html folder (or subdomain folder)
3. Upload all contents from the `dist/` folder to your web directory
4. Ensure the file structure is maintained

### 3. File Structure After Upload
Your web directory should contain:
```
public_html/
├── index.html
├── 404.html
├── sitemap-index.xml
├── robots.txt
├── favicon.svg
├── menu.svg
├── _astro/
│   ├── (optimized images and assets)
│   └── (CSS and JS files)
```

### 4. Configure .htaccess (Optional)
Create a `.htaccess` file in your web directory for better performance:

```apache
# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Set cache headers
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

# Custom 404 page
ErrorDocument 404 /404.html

# Security headers
<IfModule mod_headers.c>
    Header always set X-Frame-Options DENY
    Header always set X-Content-Type-Options nosniff
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
</IfModule>
```

## Interactive Features

The website includes several interactive components:

### Image Carousels
- **Auto-advance**: Images automatically cycle every 5 seconds
- **Manual navigation**: Click previous/next buttons or thumbnails
- **Hover pause**: Auto-advance pauses when hovering over carousel
- **Click to view**: Click any image to open in lightbox

### Lightbox Modal
- **Full-screen viewing**: Click any carousel image to view in full size
- **Navigation**: Use arrow keys or click navigation buttons
- **Scroll prevention**: Page scrolling is disabled when lightbox is open
- **Easy close**: Click outside, press Escape, or click close button

### Mobile Responsive
- All interactive features work on mobile devices
- Touch-friendly navigation
- Responsive image sizing

## Performance Features

- **Image Optimization**: All images are automatically optimized to WebP format with multiple sizes
- **Caching**: Static assets are cached for optimal performance
- **Minification**: CSS and JavaScript are minified in production
- **Sitemap**: Automatically generated for SEO at `/sitemap-index.xml`

## SEO Features

- **Meta Tags**: Proper title, description, and Open Graph tags
- **Canonical URLs**: Configured for each page
- **Sitemap**: Generated automatically
- **Robots.txt**: Configured to allow search engine crawling

## Environment Configuration

The site is configured for the domain `https://abr3havens.com`. To change this:

1. Update the `site` property in `astro.config.mjs`
2. Update the sitemap URL in `public/robots.txt`
3. Rebuild the project

## File Structure

```
├── src/
│   ├── components/          # Reusable components
│   │   ├── Header.astro
│   │   ├── ImageCarousel.astro
│   │   └── Lightbox.astro
│   ├── layouts/             # Page layouts
│   │   └── BaseLayout.astro
│   ├── pages/               # Route pages
│   │   ├── index.astro
│   │   └── 404.astro
│   ├── styles/              # Global styles
│   │   └── global.css
│   └── images/              # Optimized images
├── public/                  # Static assets
│   ├── favicon.svg
│   ├── menu.svg
│   └── robots.txt
└── astro.config.mjs        # Astro configuration
```

## Development

To run the development server:
```bash
pnpm dev
```

To build for production:
```bash
pnpm build
```

To preview the production build:
```bash
pnpm preview
```

## Troubleshooting

### Images Not Loading
- Ensure all files from `dist/` are uploaded to your web directory
- Check that the `_astro/` folder and its contents are properly uploaded
- Verify file permissions are set correctly (usually 644 for files, 755 for directories)

### Interactive Features Not Working
- Ensure JavaScript files in `_astro/` folder are uploaded and accessible
- Check browser console for any JavaScript errors
- Verify that your hosting provider supports JavaScript execution

### 404 Page Not Working
- Add the `.htaccess` configuration shown above
- Ensure `404.html` is in your web root directory
- Some hosting providers may require additional configuration

## Notes

- The project uses Tailwind CSS v4 with Vite integration
- All JavaScript has been extracted into reusable components
- Images are consistently using Astro's Image component for optimization
- The site follows Astro's recommended project structure and conventions
- All interactive features are built with vanilla JavaScript for maximum compatibility