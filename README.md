# Afia — AI-Driven Dietary \& Health Assistant

**Afia** is a state-of-the-art Flutter-based mobile application designed to empower Arabic-speaking users on their wellness journeys. By combining intuitive tracking systems with advanced conversational and visual AI, Afia acts as a personalized, culturally-aware health companion right in your pocket.

---

## 🌟 The Vision

Most global health and nutrition applications are built around Western dietary habits, English-first user experiences, and databases that lack regional cuisines. For Arabic speakers, tracking a daily diet of traditional dishes like Kabsa, Mansaf, Shawarma, or Falafel often involves complex manual estimations or yields inaccurate metrics.

**Afia bridges this gap.** 

It delivers a fully localized, Right-to-Left (RTL) interface paired with AI models trained to recognize regional Arabic dishes, understand local dialects, and provide culturally-attuned wellness guidance.

---

## 🚀 Key Product Features

### 📸 Snap Your Plate
Forget typing out ingredients. Simply snap a photo of your meal. Afia’s vision engine analyzes the image, identifies the food (including complex multi-ingredient Arabic dishes), and automatically calculates estimated calories, protein, carbohydrates, and fats. Users can inspect, edit, and log the results directly to their diary in seconds.

### 💬 Arabic AI Health Coach
A conversational assistant powered by advanced language models that acts as a personal nutritionist. The coach:
*   Engages in natural Arabic conversation.
*   Suggests healthy alternatives to traditional high-calorie recipes.
*   Explains food nutritional values and answers dietary questions.
*   Adapts dynamically to the user's daily progress (steps, water logged, calories consumed).

### 🍎 Smart Meal \& Food Logging
*   **Explore Catalog**: Browse an extensive database of international and middle-eastern ingredients integrated with global nutrition databases.
*   **Meal Slots**: Log meals under Breakfast, Lunch, Dinner, or Snacks, complete with macro breakdowns and progress rings.

### 💧 Hydration Tracker
A dedicated, beautifully animated interface to record water intake. Users can log standard cups with single taps or enter custom amounts to reach their daily hydration targets.

### 📊 Health Metrics Dashboard
A unified, premium visual dashboard displaying:
*   **Caloric Balance**: Live progress rings showing calories consumed versus daily targets.
*   **Physical Activity**: Live steps tracker and heart rate logs.
*   **Progress Tracking**: Weight logs and historical trend charts showing weight change over time.

---

## 👥 Target Audience

*   **Arabic Speakers**: Adults looking for a health tracker that respects their native language, regional dialects, and Right-to-Left layout conventions.
*   **Traditional Food Lovers**: Individuals who consume Middle Eastern cuisines and want accurate, automated nutritional breakdowns without the hassle of manual ingredient parsing.
*   **Wellness Enthusiasts**: Users looking for an all-in-one assistant coordinating activity, hydration, calories, and personalized conversational coaching.

---

## 💻 Developer \& Engineering Reference

If you are a developer, reviewer, or future maintainer looking to compile the application or inspect its architecture:

*   **Technology Stack**: Flutter (iOS + Android), Firebase (Authentication), Supabase (PostgreSQL Database, Edge Functions, Row Level Security, Storage), Gemini \& Groq APIs (AI Vision \& Conversational Chat), Dio (Networking).
*   **Architecture**: Feature-First Clean Architecture.
*   **Localization**: English and Arabic via ARB files (`intl` library) with directionality-aware widgets.
