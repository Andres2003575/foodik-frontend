# 🍽️ Foodik — Tu compañero gastronómico

> Aplicación móvil para el descubrimiento de restaurantes, gestión de reservas y división inteligente de cuentas en Bogotá, Colombia.

---

## 📱 Vista general

Foodik es una aplicación móvil desarrollada en Flutter que conecta a los usuarios con restaurantes cercanos, permitiéndoles hacer reservas, dividir cuentas entre amigos y gestionar su experiencia gastronómica de forma sencilla e intuitiva.

---

## ✨ Funcionalidades

### Para usuarios
- 🔐 **Autenticación** — Registro e inicio de sesión con JWT
- 🗺️ **Mapa interactivo** — Visualización de restaurantes cercanos con Google Maps
- 🍴 **Descubrimiento de restaurantes** — Scraping de restaurantes reales cercanos a la ubicación del usuario
- ❤️ **Favoritos** — Guardado local de restaurantes favoritos
- 📅 **Reservas** — Consulta de disponibilidad y reserva de mesas
- 🧾 **División de cuentas** — Tres modos de división:
  - **EQUAL** — División en partes iguales entre participantes
  - **INDIVIDUAL** — Cada quien paga lo suyo por plato
  - **CHAINED** — División en cadena
- 👤 **Perfil** — Gestión de datos del usuario

### Para administradores de restaurante
- 🏪 **Panel Admin** — Gestión de reservas en tiempo real
- ✅ **Gestión de estados** — Confirmar, completar o cancelar reservas
- 📊 **Vista multi-restaurante** — Administración de todos los restaurantes del admin

---

## 🛠️ Tecnologías

| Tecnología | Descripción |
|-----------|-------------|
| Flutter | Framework de desarrollo móvil multiplataforma |
| Dart | Lenguaje de programación |
| Google Maps Flutter | Mapas interactivos |
| Geolocator | Obtención de ubicación del dispositivo |
| Shared Preferences | Almacenamiento local |
| HTTP | Comunicación con el backend |

---

## 🏗️ Arquitectura

```
foodik_frontend/
├── lib/
│   ├── screens/   # Pantallas de la app
│   ├── services/  # Servicios de comunicación con la API
│   ├── config/    # Configuración (API keys - en .gitignore)
│   └── main.dart  # Punto de entrada
└── ios/           # Configuración nativa iOS
```

---

## 👤 Autor

**Andres Camilo Guerrero Mateus**

---

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Google_Maps-4285F4?style=for-the-badge&logo=google-maps&logoColor=white"/>
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white"/>
</div>
