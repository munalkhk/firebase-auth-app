Here’s a short **GitHub README.md** draft for your project 👇

````markdown
# Firebase Authentication Flutter App

A simple Android app built with **Flutter** that demonstrates **Firebase Authentication** and basic **Firestore integration**.  
Users can register, log in, log out, and update profile details. After login, a static blog feed and profile screen are displayed.

---

## 📌 Features
- Email/Password **sign up** & **login**
- **Firestore** integration for user profile (username, phone, etc.)
- Auth state listener to switch between Login/Register ↔ Home
- Simple **Home screen** with static blog items
- Firestore Security Rules for user data protection

---

## 🛠️ Setup
1. Create a new Flutter project:
   ```bash
   flutter create firebase_auth_app
````

2. Add Firebase to the Android project (download `google-services.json` → place inside `android/app/`).
3. Enable **Email/Password Authentication** and create a **Firestore database** in Firebase Console.
4. Install dependencies:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^3.4.0
     firebase_auth: ^5.1.2
     cloud_firestore: ^5.4.2
   ```
5. Initialize Firebase in `main.dart`:

   ```dart
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   ```

---

## 📂 Project Structure

* `main.dart` → Firebase init & auth state handling
* `auth_service.dart` → Register, login, logout functions
* `login_screen.dart` → Login UI + navigation
* `register_screen.dart` → Sign-up UI
* `profile_screen.dart` → Firestore profile read/write
* `home_screen.dart` → Static blog list

---

## 🔒 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📷 Screenshots

* Login Screen
<img width="1080" height="2400" alt="image" src="https://github.com/user-attachments/assets/502f034d-d2e3-4560-8fc7-1bc2ca2979c4" />

* Register Screen
<img width="1080" height="2400" alt="image" src="https://github.com/user-attachments/assets/5fd166c3-a515-4e5f-8c7d-88774ec1b44f" />

* Home (Static Blog List)
<img width="485" height="1080" alt="image" src="https://github.com/user-attachments/assets/fed00a25-1538-4d84-ae96-409f951c9061" />

* Profile Screen
<img width="485" height="1080" alt="image" src="https://github.com/user-attachments/assets/17e98558-2829-46e7-b403-2dd13d4fcc9e" />


---

## 📖 Conclusion

This project demonstrates **basic Firebase Authentication in Flutter** with a simple profile system.



