# ---- build stage ----
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build    # создаст папку /app/dist

# ---- run stage ----
FROM nginx:alpine
# свой конфиг nginx вместо дефолтного
COPY nginx.conf /etc/nginx/conf.d/default.conf
# статику из Vite кладём в стандартный корень
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
