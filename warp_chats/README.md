# Warp Chats

A Flutter application that connects to a backend server.

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine
- An IDE (VS Code, Android Studio, etc.)
- A physical device or emulator/simulator

## Setup

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies

## Environment Configuration

This app requires a backend server connection. Configure the backend URL in the `.env` file:

```
BACKEND_URL=http://<IP_ADDR>:3000
```

Replace `<IP_ADDR>` with the actual IP address of your backend server.

> **Note:** Do not use `localhost` or `127.0.0.1` as the IP address if you're testing on a physical device, as these addresses point to the device itself, not your development machine.

## Running the App

```bash
flutter run
```

## Troubleshooting

If you encounter connection issues:
- Verify your backend server is running
- Ensure the IP address in the `.env` file is correct
- Check that your device/emulator can access the network where the backend is hosted