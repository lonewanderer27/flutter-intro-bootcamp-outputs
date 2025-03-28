# Warp Chats Backend

This repository contains a Node.js Express backend application. Follow the steps below to set up and run the project.

## Prerequisites

Ensure you have the following installed on your system:

- [Node.js](https://nodejs.org/) (v16 or later recommended)
- [npm](https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager) (preferred package manager for this project)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Install Dependencies
Install the required dependencies using npm:

```bash
npm install
```

### 3. Set Up Environment Variables
Create a .env file in the root directory by copying the example file:

```bash
cp .env.example .env
```


### 4. Set Up Environment Variables
Create a .env file in the root directory by copying the example file:

```bash
cp .env.example .env
```
Edit the .env file to include environment-specific variables (e.g., Firebase credentials, API keys, etc.).

### 5. Run the Application
Start the development server:
```
npm start
```
The server will start on the port 3000 by default

Project Structure
- api/index.ts: Entry point of the application.
- api/config/: Configuration files (e.g., Firebase setup).
- api/controllers/: Controllers for handling business logic.
- api/enums/: Enumerations used across the app.
- api/middlewares/: Middleware functions for request handling.
- api/routes/: API route definitions.
- api/utils/: Utility functions.

Scripts
- pnpm start: Start the application.
- pnpm dev: Start the application in development mode with hot-reloading.
- pnpm build: Build the application for production.


