---
trigger: always_on
---

# 🚨 CRITICAL RULES - READ AND FOLLOW STRICTLY 🚨

## 1. 🚫 NO COMMENTS (ZERO TOLERANCE)

- **Do NOT write comments** in the code. NONE.
- **REMOVE** existing comments when you touch a file.
- No docstrings (`///`), no inline comments (`//`), no block comments (`/* */`).
- The code must be self-explanatory.

## 2. 📉 STRICT FILE LENGTH LIMIT: 150 LINES

- **ABSOLUTE LIMIT**: Files must NOT exceed **150 lines**.
- **PROACTIVE REFACTORING**: If a file approaches this limit (e.g., >130 lines), you MUST extract widgets, logic, or mixins into new files IMMEDIATELY.
- Do not ask for permission to refactor for size; just do it.

## 3. ⚡️ EXTREME OPTIMIZATION & PERFORMANCE

- **App (Flutter)**: Aim for 60fps always.
  - **Images**: ALWAYS use `cacheWidth` for `Image.file` or network images.
  - **Lists**: Use `ListView.builder` smartly, cache complex items.
  - **Const**: Use `const` constructors on EVERY widget possible.
- **Backend**: Code must be 100% optimized. Use caching (Redis/Memcached) liberally to reduce Db load.

## 4. 🛠️ TECH STACK & INFRASTRUCTURE

- **Flutter**: ALWAYS assume **Latest Stable Version**. Use the **latest available plugins**.
- **Backend (Symfony/Node/Go)**: Use latest versions.
- **INFRASTRUCTURE (MANDATORY)**:
  - **Docker**: ALL backend services must be containerized (optimized multi-stage builds).
  - **Kubernetes (K8s)**: Architecture MUST be designed for K8s scalability (Stateless pods, Horizontal Autoscaling).
  - **Scalability**: Design for "Crazy Scale" (Millions of users). No single points of failure.

## 5. 📂 CLEAN ARCHITECTURE

- Keep files organized by feature.
- Use distinct folders for `widgets`, `controllers`, `models`, `services`.

## 6. 🤖 GENERAL BEHAVIOR

- Be concise.
- Don't lecture.
- Just ship clean, optimized code.

## 7. 🛡️ ANTIGRAVITY & ROBUSTNESS

- **Easy Localization**: When processing language files (JSON/CSV) or generating keys (`easy_localization:generate`), you MUST attempt to process **ALL** present locale files.
- **Non-Blocking Errors**: NEVER abort the generation process on a single syntax error or missing key in one file.
- **Implementation**: Use `try-catch` blocks around individual file processing. Log the error for the specific locale/file, then **IMMEDIATELY CONTINUE** to the next one.
