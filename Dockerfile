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

# Copy built static site to Nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Provide a very small default nginx config with gzip and caching
RUN printf '%s\n' \
  'server {' \
  '  listen       80;' \
  '  server_name  _;' \
  '  root /usr/share/nginx/html;' \
  '  index index.html;' \
  '  gzip on;' \
  '  gzip_types text/plain text/css application/javascript application/json image/svg+xml;' \
  '  location / {' \
  '    try_files $uri $uri/ /index.html;' \
  '  }' \
  '  location = /robots.txt { allow all; log_not_found off; access_log off; }' \
  '}' \
  > /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ | grep -qi '<html' || exit 1

CMD ["nginx", "-g", "daemon off;"]


