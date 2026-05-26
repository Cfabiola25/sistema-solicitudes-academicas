---
agent: agent
tools: [vscode, execute, read, agent, search]
description: Genera descripciones profesionales para proyectos en LinkedIn, GitHub README y GitHub Description, además de sugerir tags relevantes para el repositorio.
---

# 📝 Prompt: Descripción Profesional para Proyectos

Template reutilizable para generar descripciones profesionales de cualquier proyecto en diferentes formatos.

---

## 📋 Input Requerido

Proporciona la siguiente información sobre tu proyecto:

1. **Nombre del proyecto**
2. **Tecnologías principales** (stack)
3. **Funcionalidades clave** (máx 5)
4. **Valor/Propuesta principal** (qué problema resuelve)
5. **Target audience** (para quién es)
6. **Diferenciador o ventaja competitiva**

---

## 📤 Output: 3 Versiones

### 1️⃣ LINKEDIN / PORTAFOLIO (150-200 palabras)

**Propósito:** Atraer a reclutadores, clientes o colaboradores

**Formato:**
- Atractivo y dinámico
- Centrado en valor y resultados
- Menciona tecnología de forma accesible
- Call-to-action implícito

**Estructura:**
- Nombre + verbo fuerte
- Stack técnico (breve)
- Funcionalidades estrella (2-3)
- Resultado/Impacto
- Diferenciador (experiencia, años, etc.)

**Tono:** Profesional pero dinámico, inspirador

---

### 2️⃣ GITHUB README (80-120 palabras)

**Propósito:** Descripción clara en el README principal

**Formato:**
- Conciso y técnico
- Información funcional
- Fácil de escanear

**Estructura:**
- Nombre + descripción funcional
- Stack principal (máx 3 tecnologías)
- Característica principal (qué hace único)
- Tecnologías secundarias si aplica

**Tono:** Directo y claro

---

### 3️⃣ GITHUB DESCRIPTION (una línea)

**Propósito:** Descripción corta para el repositorio

**Formato:**
- Máximo 125 caracteres (límite de GitHub)
- Clara y específica

**Estructura:**
- Nombre + qué es + para quién + valor clave

**Tono:** Muy directo

---

## 🏷️ GITHUB TAGS (máx 15)

### Categorías de Tags

| Categoría | Ejemplos |
|-----------|----------|
| **Stack Frontend** | nextjs, react, vue, angular, tailwindcss, typescript |
| **Stack Backend** | nodejs, python, django, fastapi, supabase, postgresql |
| **Tipo de Proyecto** | landing-page, cms, admin-panel, api, library, template |
| **Funcionalidad** | seo, emailjs, authentication, payment, analytics |
| **Nicho/Dominio** | ecommerce, saas, finanzas, seguros, educación |
| **Escala/Performance** | responsive, mobile-first, pwa, serverless |
| **Estado/Propósito** | website, open-source, starter-template, boilerplate |

### Prioridad
1. Stack tecnológico (2-3 tags)
2. Tipo de proyecto (1-2 tags)
3. Funcionalidades clave (3-4 tags)
4. Nicho específico (1-2 tags)
5. Otros (responsive, open-source, etc.)

---

## 📚 Ejemplo: Seguros con Maritza

### Input
```
1. Nombre: Seguros con Maritza
2. Tech: Next.js, Tailwind, Supabase, EmailJS
3. Funcionalidades: Landing, calculadora, secciones educativas, panel admin, CMS
4. Valor: Convertir visitantes en leads, educación sobre seguros
5. Target: Asesores de seguros, agencias
6. Diferenciador: 40 años de experiencia, CMS sin código
```

### 1️⃣ LinkedIn/Portafolio (Output)
```
Seguros con Maritza — Plataforma web moderna para asesoría de seguros que combina 
educación, tecnología y experiencia. Landing optimizado con Next.js (App Router, 
Tailwind), herramientas interactivas (calculadora de pólizas, glosario, guía de 
mitos), formulario de contacto integrado, y panel administrativo intuitivo. Todo 
preparado para SEO, responsive en cualquier dispositivo y diseñado para convertir 
visitantes en clientes. Respaldado por 40 años de expertise en seguros.
```

### 2️⃣ GitHub README (Output)
```
Landing para asesoría de seguros con Next.js, Tailwind, secciones educativas, 
calculadora interactiva, formularios EmailJS y SEO completo. Panel administrativo 
para gestionar contenido sin código. Optimizado para conversión en cualquier dispositivo.
```

### 3️⃣ GitHub Description (Output)
```
Seguros con Maritza — Landing moderno con Next.js, calculadora interactiva, 
CMS administrativo y SEO listo. Diseñado para convertir visitantes en leads.
```

### Tags (Output)
```
nextjs, tailwindcss, typescript, react, supabase, landing-page, cms, admin-panel, 
emailjs, seo, seguros, website, responsive, vercel, es
```

---

## 🚀 Cómo usar este Prompt

1. **Rellena los 6 inputs** con información de tu proyecto
2. **Aplica las 3 estructuras** (LinkedIn, GitHub README, GitHub Description)
3. **Selecciona 10-15 tags** según las categorías
4. **Obtén descripción + tags** listos para usar
5. **Ajusta el tono** según tu audiencia

---

## 💡 Tips

- **LinkedIn:** Sé inspirador, menciona resultados, humaniza
- **GitHub README:** Sé técnico pero accesible, respeta formato markdown
- **GitHub Description:** Una línea potente, máx 125 caracteres
- **Tags:** Combina populares (nextjs, react) con específicos (seguros, insurance)
- **Palabras clave:** Incluye tecnologías y funcionalidades principales

---

**Última actualización:** 29/04/2026  
**Propósito:** Generar descripciones profesionales reutilizables  
**Versión:** 1.0
