# CoastLine
# Nuevo Amanecer Institute SwiftUI Project

This project is a SwiftUI-based iOS development project developed for Nuevo Amanecer Institute. It was created using Xcode for iPads running iOS 16 or higher. The aim of the project was to provide a platform for teachers to add and manage students, incorporating personalized pictograms and interactive games to stimulate the students' motor skills.

## Technologies Used

- SwiftUI: SwiftUI is a modern framework for building user interfaces across Apple platforms.
- Firebase Firestore: Firestore is a flexible, scalable NoSQL cloud database provided by Firebase.
- Firebase Authentication: Firebase Authentication enables secure user authentication and registration.
- Firebase Storage: Firebase Storage provides secure cloud storage for file uploads and downloads.

## Prerequisites

To run this project locally, you will need:

- Xcode: [Download Xcode](https://developer.apple.com/xcode/)
- An iPad running iOS 16 or higher
- Firebase account: [Create a Firebase account](https://firebase.google.com/)

## Getting Started

1. Clone the repository:

```
git clone https://github.com/pabloerhard/CoastLineSwift.git
```

2. Open the project in Xcode.

3. Configure Firebase:

- Create a Firebase project in the Firebase console.
- Enable Firebase Firestore, Firebase Authentication, and Firebase Storage.
- Copy the Firebase configuration credentials into the project.
- Set up the appropriate security rules for Firestore and Storage.
Rules for Firestore:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    match /tutores/{tutorId} {
      allow read, write: if request.auth != null;
    }
    
    match /alumnos/{alumnoId} {
      allow read, write: if request.auth != null;
    }
    //Add more if more collections are created
  }
}
```
Rules for storage:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read;
      allow write: if request.auth != null;
    }
  }
}

```
4. Build and run the project on your iPad.

# License
This project is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.

# Contact
For any inquiries, please contact the project maintainers:
- Pablo Erhard: mailto:A01721124@tec.mx
- Nicolas Aguirre: mailto:nico03aguirre@gmail.com


Created on: 12/06/2023
