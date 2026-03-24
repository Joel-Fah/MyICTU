# BDEN (Blood Donation Emergency Network)

> **Give blood. Save lives.**

BDEN is a mobile platform connecting blood donation centers (Organizers) with potential donors in real-time.

## Features

### For Donors
- **Feed:** Browse active blood donation campaigns near you.
- **Pledge:** Commit to donating blood for specific campaigns.
- **Profile:** Manage your blood type and donation history.
- **Notifications:** Get alerted about urgent needs and pledge updates.

### For Organizers (Health Centers)
- **Dashboard:** Track active campaigns and donor pledges.
- **Create Campaign:** Launch new calls for blood donation with urgency levels.
- **Management:** Confirm donor attendance and successful donations.

## Tech Stack

- **Framework:** Flutter (v3.35.6 via FVM)
- **State Management:** GetX
- **Navigation:** go_router
- **Backend:** Firebase (cloud_firestore, firebase_auth, firebase_storage)
- **UI:** Google Fonts (Plus Jakarta Sans), HugeIcons, flutter_animate

## Project Structure

- `lib/core`: Constants, Enums, Utils
- `lib/data`: Models, Repositories, Services (Firebase implementation)
- `lib/features`: Feature-based modules (Auth, Campaigns, Dashboard, etc.)
- `lib/shared`: Reusable widgets and layouts
- `lib/routes`: App navigation configuration

## Setup & Run

1. **Prerequisites:** Flutter SDK, FVM, Firebase CLI.
2. **Install Dependencies:**
   ```bash
   fvm flutter pub get
   ```
3. **Run App:**
   ```bash
   fvm flutter run
   ```

## Firebase Configuration

This project uses Firebase. Ensure you have `firebase_options.dart` generated for your project ID (`bden-f203e`).

### Security Rules & Indexes
- Rules: `firestore.rules`
- Indexes: `firestore.indexes.json`
Deploy using: `firebase deploy --only firestore`
