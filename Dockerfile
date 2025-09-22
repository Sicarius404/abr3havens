############################
# Build stage
############################
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies separately for better caching
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml* ./

# Use pnpm if lockfile exists; fall back to npm
RUN if [ -f pnpm-lock.yaml ]; then \
      corepack enable && corepack prepare pnpm@latest --activate && pnpm install --frozen-lockfile; \
    else \
      npm ci; \
    fi

# Copy the rest of the project
COPY . .

# Build the Astro site (static output)
RUN if [ -f pnpm-lock.yaml ]; then \
      pnpm build; \
    else \
      npm run build; \
    fi

############################
# Runtime stage
############################
FROM nginx:1.27-alpine AS runner

# Install curl for healthcheck compatibility (e.g., Coolify)
RUN apk add --no-cache curl

# Copy built static site to Nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Debug: List contents to verify build
RUN echo "=== Listing /usr/share/nginx/html contents ===" && \
    ls -la /usr/share/nginx/html/ && \
    echo "=== Listing _astro directory ===" && \
    ls -la /usr/share/nginx/html/_astro/ 2>/dev/null || echo "_astro directory not found"

# Provide a comprehensive nginx config for static assets
RUN printf '%s\n' \
  'server {' \
  '  listen       80;' \
  '  server_name  _;' \
  '  root /usr/share/nginx/html;' \
  '  index index.html;' \
  '' \
  '  # Enable gzip compression' \
  '  gzip on;' \
  '  gzip_vary on;' \
  '  gzip_min_length 1024;' \
  '  gzip_types text/plain text/css text/xml text/javascript application/javascript application/json application/xml+rss image/svg+xml;' \
  '' \
  '  # Cache static assets' \
  '  location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|eot)$ {' \
  '    expires 1y;' \
  '    add_header Cache-Control "public, immutable";' \
  '    add_header Access-Control-Allow-Origin "*";' \
  '    try_files $uri =404;' \
  '  }' \
  '' \
  '  # Handle _astro directory specifically' \
  '  location /_astro/ {' \
  '    expires 1y;' \
  '    add_header Cache-Control "public, immutable";' \
  '    add_header Access-Control-Allow-Origin "*";' \
  '    try_files $uri =404;' \
  '  }' \
  '' \
  '  # Handle all other requests' \
  '  location / {' \
  '    try_files $uri $uri/ /index.html;' \
  '  }' \
  '' \
  '  # Special handling for robots.txt' \
  '  location = /robots.txt {' \
  '    allow all;' \
  '    log_not_found off;' \
  '    access_log off;' \
  '  }' \
  '}' \
  > /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=300s --timeout=3s --retries=3 CMD curl -fsS http://localhost/ >/dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]


