# Desplegar el Frontend

Tu app es móvil (Android/iOS), no un sitio web — por eso "desplegar en la nube"
significa algo distinto aquí que para el backend. Dos caminos:

## Camino A: EAS Build — genera la app real (recomendado)

Esto produce un `.apk` que cualquiera puede instalar en su celular, sin
necesitar Expo Go ni estar en tu misma red WiFi.

**Gratis:** 15 builds de Android + 15 de iOS por mes, sin tarjeta.

```bash
cd frontend
npm install -g eas-cli
eas login                      # crea cuenta gratis en expo.dev si no tienes
eas build:configure            # vincula el proyecto (usa el eas.json ya incluido)
eas build --platform android --profile preview
```

Al terminar (10-20 min), EAS te da un link de descarga del `.apk` — se lo
mandas a cualquiera (tu ingeniero, tus compañeros) y lo instalan directo,
sin Expo Go.

> Recuerda: antes de esto, `BACKEND_URL` en `src/config/env.ts` debe apuntar
> a tu backend ya desplegado en la nube (ver `backend/DEPLOY.md`), no a tu
> IP local — si no, el `.apk` no podrá analizar el entorno fuera de tu WiFi.

## Camino B: Exportar a web + Docker (opcional, con limitaciones)

Si además quieres una versión que corra en un navegador (para mostrarla
como demo sin instalar nada), puedes exportar a web y containerizarla:

```bash
cd frontend
docker build -t orientago-web .
docker run -p 8080:80 orientago-web
# abre http://localhost:8080
```

**Limitación real:** la pantalla de Navegación Asistida usa
`react-native-webview` para el mapa, que **no tiene soporte web**. Esa
pantalla fallará o saldrá en blanco en la versión web hasta que se adapte
(reemplazar el `WebView` por un `<iframe>` cuando `Platform.OS === "web"`).
El resto de la app (Login, Home, Analizar Entorno con cámara del navegador)
debería funcionar razonablemente bien.

### Dónde desplegar la imagen Docker del web (gratis)
- **Render** (Static Site, sin necesitar Docker realmente — más simple)
- **Hugging Face Spaces** (Docker SDK, mismo proceso que el backend)
- Si no necesitas Docker específicamente: **Vercel**, **Netlify** o
  **Cloudflare Pages** son más simples para una app web estática y también
  gratis — conectas el repo y listo, sin Dockerfile.
