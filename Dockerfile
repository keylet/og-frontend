# OrientaGo — versión WEB (opcional)
#
# ADVERTENCIA IMPORTANTE: esto NO reemplaza la app móvil real. La pantalla
# de Navegación Asistida usa react-native-webview para el mapa, que no
# funciona en web — esa pantalla probablemente falle o se vea en blanco
# hasta que se adapte (ej. reemplazar el WebView por un <iframe> cuando
# Platform.OS === "web"). Úsalo como vista previa/demo del resto de la
# app, no como sustituto de un build móvil real (ver DEPLOY.md -> EAS Build).

FROM node:20-slim AS build
WORKDIR /app

COPY package.json package-lock.json* .npmrc ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npx expo export --platform web

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
