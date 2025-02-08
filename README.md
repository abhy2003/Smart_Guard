# Smart Guard

Smart Guard is an IoT-based smart lock system that enhances home security by integrating a mobile application with Raspberry Pi-controlled hardware. The project is built with Flutter for the mobile app, Django for the backend, and Raspberry Pi 5 for hardware control.

## Features

### Mobile App Features
- **User Authentication**: Secure login and registration.
- **Remote Lock/Unlock**: Control the smart lock via the mobile app.
- **Real-Time Alerts**: Get notified when motion is detected.
- **Activity Log**: View the history of lock/unlock actions.
- **Live Monitoring**: Check real-time security status.
- **Video Player**: Live stream video from the lock.
- **Add Lock**: Register new smart locks within the app.
- **Print Lock Status**: View and print the current lock status.

### Hardware Components
- **Raspberry Pi 5** (running Ubuntu): Central controller for the smart lock system.
- **Relay Module**: Controls the electronic lock mechanism.
- **Motion Sensor**: Detects unauthorized movements.
- **Buzzer**: Alerts users of security breaches.

## Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Django (Python)
- **Database**: PostgreSQL
- **Hardware**: Raspberry Pi 5 (Ubuntu), Relay Module, Motion Sensor, Buzzer

## Installation

### Mobile App
1. **Clone the repository**
   ```sh
   git clone https://github.com/yourusername/smartguard.git
   cd smartguard
   ```
2. **Install dependencies**
   ```sh
   flutter pub get
   ```
3. **Run the application**
   ```sh
   flutter run
   ```

### Backend (Django)
1. **Set up a virtual environment**
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```
2. **Install dependencies**
   ```sh
   pip install -r requirements.txt
   ```
3. **Run the Django server**
   ```sh
   python manage.py runserver
   ```

## Future Enhancements
- **Face Recognition** for added security.
- **Cloud Backup** for activity logs.
- **Voice Control Integration** with Alexa/Google Assistant.

## Contributing
Feel free to submit pull requests or report issues in the repository.

## Contact
For any queries, reach out to me at **your_email@example.com**.

---
Made with ❤️ using Flutter and IoT.
