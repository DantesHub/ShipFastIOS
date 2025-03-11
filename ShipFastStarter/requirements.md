
# Tomo Time Requirements Document

## 1. Introduction

**Tomo Time** is a mobile application that gamifies focus and productivity by merging a Pomodoro timer with collectible, Pokémon‑inspired companions (“Tomos”). The app motivates users to concentrate by rewarding them with EXP, coins, and collectibles for completing focus sessions, whether solo or in groups.

---

## 2. Vision & Goals

- **Vision:**    
    To create a fun and engaging productivity app where every focus session is a step toward leveling up your favorite digital companion while connecting with friends.    
- **Goals:**
    - Encourage longer and more effective focus sessions.
    - Foster a sense of community through group study sessions and social features.
    - Deliver an immersive, gamified experience that rewards persistence and progress.
    - Seamlessly transition users from a trial (local data) mode to a fully authenticated social platform.

---

## 3. Core Features

### 3.1. Focus Sessions

- **Session Configuration:**
    - **Duration:** Users can choose sessions ranging from 15 minutes to 3 hours.
    - **Rewards Scaling:** Longer sessions yield more EXP and coins.
    - **Tomo Companion:**
        - Users select a Tomo at the start of each session.
        - The chosen companion gains EXP as the session progresses.
- **Group Sessions:**
    - Users can only join rooms of their friends.
        - On the home screen, a “+ Friends” icon allows users to invite friends to join a session:
            - Pull up a list of friends.
            - Send them a push notification or an iMessage containing a deep link with the room code.
            - Alternatively, open the contact book to invite new users to join the app.
    - one user creates a hosted session
        - the host edits the total time ⇒ sends a silent notification to others that will update their UIs
        - the host taps start ⇒ this triggers a silent notification to the other 3 users that sends a silent notification
    - **Multiplayer:**
        - Up to 4 users can join a session.
        - Each additional participant increases the EXP multiplier (e.g., a 3‑person session gives a 3× EXP boost).
    - **Synchronization:**
        - Leverage Firebase’s realtime capabilities (via Firebase Realtime Database or Firestore realtime listeners) to manage session participation and ensure synchronized timers across devices.
- **Session Interruption Handling:**
    - **Foreground Requirement:**
        - If a user leaves the app mid-session, the accompanying Tomo begins to lose HP.
    - **Penalty:**
        - On returning after an interruption, the user will see a modal indicating that all progress from the current session is lost. For example, if a user leaves a 3‑hour session after 2 hours, they must restart the session upon return.
    - **Group Impact:**
        - In a group session, one user leaving will compromise the session for all participants.
- **Notifications:**
    - Users receive notifications when:
        - A focus session ends.
        - A break session begins.
        - The user has been away for more than 10 seconds during a focus session.

---

### 3.2. Onboarding & User Authentication

- **Guest Mode:**
    - Users can initiate focus sessions without logging in.
    - Session data is stored locally (using Async Storage) until the user opts to sign up.
- **Transition to Authenticated Mode:**
    - When the user opts to sign up, they will be prompted to authenticate using their phone number via Firebase Phone Authentication.
    - Upon authenticating, all locally stored session data is synchronized with Firebase.
    - Social features (such as friends and group sessions) are locked until the user registers.
- **User Prompting:**
    - The app will include in‑app prompts or gentle reminders encouraging users to sign up to unlock full features.

---

### 3.3. In-App Store

- **Currency & Purchases:**
    - Users earn coins by completing focus sessions.
    - Mystery boxes are purchased using coins and are not randomly dropped.
- **Mystery Boxes:**
    - **General Mystery Box:**
        - **Cost:** 500 coins.
        - **Contents:**
            - Drop rates are defined by design, for example:
                - **Legendary Egg:** 5% drop rate.
                - **Other Eggs:** The remaining 95% divided among common, rare, super rare, and epic (e.g., Common: 50%, Rare: 25%, Super Rare: 10%, Epic: 10%).
    - **Golden Mystery Box:**
        - **Cost:** 3000 coins.
        - **Contents:**
            - Guaranteed to yield a legendary egg.

---

### 3.4. Incubation Room

- **Egg Management:**
    - Collected eggs must be incubated for a set duration before hatching into a Tomo.
    - **Incubation Durations:**
        - **Common Egg:** 1 day
        - **Rare Egg:** 2 days
        - **Super Rare Egg:** 3 days
        - **Epic Egg:** 5 days
        - **Legendary Egg:** 7 days

---

### 3.5. Tomodex

- **Collection Overview:**
    - A grid view displays all collected Tomos.
    - Tapping on a Tomo opens a detail view with:
        - Current level and EXP.
        - Total minutes focused.
        - Session history.
        - (Optional) Additional details such as special abilities or evolution status.
- **Filtering & Sorting:**
    - Options for filtering or sorting by level, acquisition date, etc., for enhanced usability.

---

### 3.6. Friends Screen

- **Social Integration:**
    - **Display:**
        - A list of friends showing:
            - Online status (updated approximately every 10 seconds via Firebase realtime listeners).
            - Last online timestamp.
            - Current study status, including the Tomo they’re using and its level.
            - Total number of Tomos collected.
    - **Interaction:**
        - A button to send a focus session request if a friend is not already in a session.
    - **Backend:**
        - All friend and social mechanics are handled via Firebase.
- **Invitation:**
    - Friends can be invited through push notifications (using Firebase Cloud Messaging) or deep links sent via SMS (leveraging the phone number-based system).

---

### 3.7. Profile Screen

- **Personal Dashboard:**
    - Displays user statistics, including:
        - Total hours studied.
        - Graphs showing daily, weekly, and monthly focus trends.
    - **Tomo Party Stats:**
        - Details for each Tomo, such as:
            - Total focus minutes.
            - Session dates.
            - Level and EXP.
    - **Customization:**
        - Future iterations may include profile customization options (avatars, bios, etc.).

### 3.8 Stats Screen
- **Stats Overview:**
    - Displays user statistics, including:
        - Total hours studied.
        - Graphs showing daily, weekly, and monthly focus trends.
        - List view of previous focus sessions with metadata:
            - Date
            - Duration
            - Tomo
            - Level
            - EXP            
---

## 3.a Styling
- we're using nativewind for styling

## 4. Technologies

- **Frontend:**
    - SwiftUI
- **Backend:**
    - **Firebase:**
        - Used for authentication (via phone number), realtime database functionality (using Firebase Realtime Database and/or Firestore realtime listeners), and data storage.
- **Data Synchronization & Local Storage:**
    - SwiftData 
- **Notifications:**
    - Utilize Firebase Cloud Messaging to implement push notifications for session updates and break notifications.

---

## 5. Additional Considerations

### 5.1. Performance & Scalability

- **Realtime Performance:**
    - Ensure that group sessions and online status updates scale well as user numbers grow.
- **Data Sync:**
    - Robust handling of local caching and synchronization with Firebase, especially for users with intermittent connectivity.

### 5.2. Security & Data Privacy

- **Data Protection:**
    - Secure transmission and storage of user data both locally and in Firebase.
- **Privacy Policies:**
    - Clearly communicate how user data is collected, used, and stored.

### 5.3. User Experience & Accessibility

- **UI/UX:**
    - Intuitive navigation between focus sessions, the in‑app store, friends, and profile screens.
    - Adherence to accessibility standards.
- **Gamification:**
    - Engaging animations and interactive elements to enhance the gamified experience.

### 5.4. Testing & Deployment

- **Quality Assurance:**
    - Extensive testing (unit, integration, and end‑to‑end tests) for all core features.
- **CI/CD:**
    - Establish pipelines for continuous integration and deployment across staging and production environments.

---

## 6. Summary of Clarifications & Next Steps

1. **Focus Session Penalties:**
    - Leaving a session early causes the loss of all progress.
    - A modal will inform the user upon return that the session must be restarted.
2. **Mystery Box Mechanics:**
    - Boxes are purchased with coins.
    - Regular Mystery Box drop rates: Legendary egg at 5% (with other rarities distributed as per design).
3. **Friend & Social Mechanics:**
    - All operations (friend status, invitations, session requests) are handled via Firebase.
    - Friend online statuses are updated using Firebase realtime listeners approximately every 10 seconds.
4. **Incubation Durations:**
    - Common: 1 day, Rare: 2 days, Super Rare: 3 days, Epic: 5 days, Legendary: 7 days.
5. **Data Sync Strategy:**
    - Use Async Storage for local data.
    - Use Zustand to maintain continuous sync between local storage and Firebase.

---

## 7. Styling & UX Examples

- **Colors:**
    - Main background: `#E7E7DD`
    - Secondary color: `#C7C7B7`
    - Accent color: `#1A73BC`


## Leveling / Reward System
- EXP Required for Next Level = 200 × (Current Level)^2
- Examples:
    • Level 1 → Level 2:
     200 × (1)^2 = 200 EXP
    • Level 2 → Level 3:
     200 × (2)^2 = 800 EXP
    • Level 5 → Level 6:
     200 × (5)^2 = 5,000 EXP
    • Level 10 → Level 11:
     200 × (10)^2 = 20,000 EXP
- if user has 1 buddy in a focus session == 2x EXP, more than 1 buddy == 3x EXP (capped at 3x)
- 1 coin == minute of studying. 100 coins = 100 minutes of studying.
- anything under 1 minute is 1 coin, anything under 1 minute is 1 exp.
