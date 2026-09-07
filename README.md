# Ajeal

A shared, role-aware mobile system for managing child development and
therapy plans while giving parents visibility into progress.

Tagline: Connected child-care workflows for practitioners and parents.

---

## Summary

Ajeal is a Flutter mobile application that centralizes child profiles, therapy
goals, scheduled sessions, progress records, family communication, and
parent-facing updates. The product supports two primary roles: practitioners
and parents, with role-specific entry points and shared Firebase-backed data.

Short description: A dual-role mobile system for managing child development
and therapy plans while giving parents visibility into progress.

Platforms: Android, iOS
Year: 2025
Version: 1.0.0+1

---

## Problem & Solution

- Problem: Child-development workflows require aligned case histories, plans,
	session follow-ups, and parent communication — often siloed across tools.
- Solution: Ajeal provides a single operational record (Cloud Firestore),
	practitioner tools for planning and recording sessions, and a focused
	parent dashboard that surfaces progress and communication.

---

## Key Features

- Dual-role access (practitioner + parent)
- Comprehensive child profiles (personal, health, assessments, plans)
- Goal-based care planning with a predefined goal library
- Generated session schedules from selected goals and dates
- Session outcome recording (tasks, ratings, notes)
- AI-assisted progress analysis (Gemini integration)
- Daily notes with optimistic UI and rollback on failure
- Firestore-backed practitioner-parent chat with streaming updates
- Localization (English & Arabic) and light/dark themes

---

## Tech & Architecture

- Framework: Flutter, Dart
- State management: `flutter_bloc` (Cubit + BlocBuilder/BlocProvider)
- Backend: Firebase (Firestore, Authentication)
- AI: Gemini (via `flutter_gemini`)
- Local storage: `shared_preferences`
- Image caching, charts, PDF generation and other utilities via pub packages

Architecture notes: feature-organized Flutter app with Cubit/BLoC for state,
imperative Navigator routing inside a `GetMaterialApp` shell, and direct
Firestore access in repositories and screens.

---

## Demo Flow (recommended screenshots)

1. Role selection (practitioner / parent)
2. Practitioner authentication and onboarding
3. Add child flow (create profile, select goals)
4. Child details and goals
5. Session detail (tasks, ratings, notes)
6. Parent dashboard (progress, goals, schedule)
7. Chat between practitioner and parent

---

## Design Gallery

The repository includes design screenshots used in the README gallery. These
are located in `assets/design/screens/` and are already referenced below.

![Ajeal]<img width="1536" height="1024" alt="ajeal-benha" src="https://github.com/user-attachments/assets/1a5af7a0-26e5-4c39-8360-63ceee843e3a" />
![Role Selection]<img width="1080" height="1080" alt="screenshot-03" src="https://github.com/user-attachments/assets/895e377a-8777-4eec-beff-cb2c896ba883" />
![Practitioner list]<img width="1080" height="1080" alt="screenshot-09" src="https://github.com/user-attachments/assets/feb8324f-d425-4cfc-b489-41f6efbe3848" />
![Child detail]<img width="1080" height="1080" alt="screenshot-07" src="https://github.com/user-attachments/assets/3c533d5d-bf8d-4844-96c0-02e9e9b3b787" />

![Session detail]<img width="1080" height="1080" alt="screenshot-08" src="https://github.com/user-attachments/assets/b28da3c4-5a9a-456e-abe3-16496c2766ca" />

![Parent dashboard]<img width="1080" height="1080" alt="screenshot-06" src="https://github.com/user-attachments/assets/c5f199f4-70ee-45b4-a8bd-cb0aea46b97c" />

![Chat sample]<img width="1080" height="1080" alt="screenshot-02" src="https://github.com/user-attachments/assets/2824ed80-66e1-43e9-a10a-df281654e748" />

![Reports]<img width="1080" height="1080" alt="screenshot-01" src="https://github.com/user-attachments/assets/7ce21658-db2d-461a-af1b-7a1e643ffbdb" />


---

## Project metadata (from design export)

- Category: Child Development and Therapy Management
- Project goal: Improve continuity between assessment, treatment execution,
	progress tracking, and parent communication.
- Screens (design estimate): 20

---

## How to run (local dev)

1. Ensure Flutter SDK is installed and on your PATH.
2. From the project root run:

```bash
flutter pub get
flutter run
```

3. For platform-specific setup (Android/iOS) follow Flutter's standard setup
	 and make sure `google-services.json` and iOS Google plist files are
	 configured if you intend to run Firebase features.

---

## Contributing

If you'd like to refine the README content, improve screenshots, or add a
design system reference, open a PR. Suggested next actions:

- Rename design images for stable references (e.g. `screen-01.png`).
- Add links to the design source (Figma/Behance) if available.
- Add `SECURITY.md` and `CONTRIBUTING.md` when the project accepts external
	contributions.

---

If you'd like, I can (pick one):

- rename the design images inside `assets/design/screens/` to friendly names and
	update the README references (recommended), or
- produce a short `DESIGN.md` with the `Ajeal.json` details organized for a
	portfolio export.
