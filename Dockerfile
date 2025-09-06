# Build stage
FROM node:22-alpine AS build
WORKDIR /app

# Устанавливаем зависимости
COPY package*.json ./
RUN npm install

# Копируем исходный код
COPY . .

# Сборка Vite-приложения (создаёт /dist)
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
