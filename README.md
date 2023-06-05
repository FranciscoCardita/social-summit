# Social Summit

## Initial Setup

1. Install [Node.js](https://nodejs.org/en/download/)
2. Install [Flutter](https://flutter.dev/docs/get-started/install)
3. Install [Android Studio](https://developer.android.com/studio/install)

### Backend

#### Install Dependencies

```bash
cd backend
npm install
```

### Create .env File

Create a `.env` file in the `backend` directory with the following variables:

```bash
MONGODB_URI="mongodb+srv://social:social123@social-summit.snuvhxq.mongodb.net/social-summit?retryWrites=true&w=majority"
PORT=5000
```

#### Run Server

> **Note:** No need to run the server, the server is already running on a cloud server.
> All the frontend requests are being served from the cloud server.

```bash
npm start
```

### Frontend

#### Install Dependencies

```bash
cd frontend
flutter pub get
```

#### Run App

```bash
flutter run
```

## Important Information

### Testing Accounts

| Email          | Password |
| -------------- | -------- |
| test@dummy.com | test123  |
| jamal@test.com | test123  |
| alice@test.com | test123  |
| bob@test.com   | test123  |

### Unit Tests

- Run the following command to run a single unit test file (e.g. `test/unit_test/file_test.dart`):

```bash
flutter test integration_test/<file_test>.dart
```

### API Endpoints

See the [API endpoints documentation](backend/Routes.md) for more information.

### Database Schema

See the [database schema documentation](backend/Database.md) for more information.