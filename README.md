# SISPOL-7 (CS50x Final Project)

## Video Demo
<https://youtu.be/UcKxuPaq5Ho>

## Author
Pedro Andrés Arévalo Samaniego  
Information Technology Engineer — Ecuador  
edX: petterarevalo1998  
GitHub: Petter1998   

## Description
SISPOL-7 is a multiplatform application built with Flutter (Dart) and developed as the final project for Harvard University’s CS50x course. The project is designed as a **hypothetical institutional system** for managing a **police vehicle fleet** operating under continuous service (24/7). Its purpose is to simulate a realistic administrative platform, focusing on maintainability and scalability rather than a minimal tutorial example.

The application was originally developed in **Spanish**, my native language, to speed up implementation and define user-facing flows more clearly. After reaching a stable functional state, the documentation and presentation were adapted to English to match CS50x requirements.

As an **Information Technology Engineer**, I intentionally adopted the **Model–View–Controller (MVC)** architecture to ensure separation of concerns, cleaner organization, and easier future expansion.

## Key Features
- Multiplatform Flutter application (tested on Flutter Web / Desktop environments).
- **Firebase Authentication** integration:
  - User account creation
  - Secure login
- Modular, institutional-style interface designed for fleet management workflows.
- Example administrative flows demonstrated in the video:
  - Vehicle registry viewing and searching
  - Maintenance request creation
  - Maintenance record review (CRUD operations)
  - Role/module management concepts (permissions)
  - Dashboard-style visual summaries for decision support

> Note: This is a hypothetical system created for academic purposes and does not represent an official police platform.

## Architecture (MVC)
The project follows the Model–View–Controller pattern:

- **Models (`lib/models/`)**
  Data structures and entities used by the system.
- **Views (`lib/views/`)**
  UI screens and layout components.
- **Controllers (`lib/controllers/`)**
  Application logic and coordination between views and models.
- **Widgets (`lib/widgets/`)**
  Reusable UI components shared across screens.

Core files:
- `lib/main.dart`: Application entry point
- `lib/firebase_options.dart`: Firebase configuration generated for the project

## Technologies Used
- Flutter / Dart
- Material Design
- Firebase Authentication
- Git & GitHub (version control)

## How to Run
1. Install Flutter SDK and verify setup:
   ```bash
   flutter doctor






