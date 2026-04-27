# 🚀 Orbit Backend API Guide

This guide details how to run the newly created FastAPI backend and interact with it using tools like **Postman** or **Insomnia**. It also explains how to automatically access the built-in Swagger documentation. 

---

## 🛠️ 1. Setup & Running the Server Locally

To start using your backend, you'll need Python installed. Follow these steps to fire up your API:

**Step 1:** Open your terminal and navigate to the `backend` folder where the server files live:
```bash
cd backend
```

**Step 2:** (Optional but recommended) Create and activate a fast virtual environment:
```bash
python -m venv venv
# On Ubuntu/MacOS:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

**Step 3:** Install the required dependencies:
```bash
pip install -r requirements.txt
```

**Step 4:** Start the server using Uvicorn with auto-reload enabled:
```bash
uvicorn main:app --reload
```
You should see a message stating that the Uvicorn is running on `http://127.0.0.1:8000`. Your backend is now successfully active! 

---

## 📖 2. Built-in Swagger API Documentation

FastAPI natively generates amazing API documentation that you can interact with right in your browser. 

Once your server is running via `uvicorn`, simply visit the following link in your browser:
**➡️ [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)**

You'll see a beautiful **Swagger UI** page where you can check endpoints, see required models, and even execute testing requests directly by clicking the "**Try it out**" button on each endpoint. Alternatively, you can browse ReDoc documentation at **http://127.0.0.1:8000/redoc**.

---

## 📬 3. Testing in Postman / Insomnia

If you prefer testing with native apps like Postman or Insomnia, follow this step-by-step connection guide.

**Base URL:** 
Set your base URL variable in Postman/Insomnia to: `http://127.0.0.1:8000`

### 1) Check Server Status
- **Method:** `GET`
- **URL:** `http://127.0.0.1:8000/`
- **Action:** Hit *Send*. You should simply receive the welcome message verifying the server is active.

### 2) Create a New Item (POST)
- **Method:** `POST`
- **URL:** `http://127.0.0.1:8000/items/`
- **Headers:** `Content-Type: application/json`
- **Body (JSON):**
  ```json
  {
    "title": "Finish Orbit documentation",
    "description": "Write a guide for Insomnia and Postman usage.",
    "completed": false
  }
  ```
- **Action:** Hit *Send*. The DB will generate an `id` for this item (e.g., `id: 1`).

### 3) Fetch All Items (GET)
- **Method:** `GET`
- **URL:** `http://127.0.0.1:8000/items/`
- **Action:** Hit *Send*. It will return an array literal of all items in the database.

### 4) Fetch Single Item by ID (GET)
- **Method:** `GET`
- **URL:** `http://127.0.0.1:8000/items/1`
- **Action:** Hit *Send*. (Make sure `1` corresponds to an ID that you received when hitting the `POST` request).

### 5) Update an Item (PUT)
- **Method:** `PUT`
- **URL:** `http://127.0.0.1:8000/items/1`
- **Headers:** `Content-Type: application/json`
- **Body (JSON):**
  ```json
  {
    "title": "Finish Orbit documentation",
    "description": "Write a guide for Insomnia and Postman usage.",
    "completed": true
  }
  ```
- **Action:** Hit *Send*. This will update the status of the item with ID `1` to `completed: true`.

### 6) Delete an Item (DELETE)
- **Method:** `DELETE`
- **URL:** `http://127.0.0.1:8000/items/1`
- **Action:** Hit *Send*. The item will be deleted.

---
### 🌟 A Note on the Database:
This project uses **SQLite**. When you run the server for the very first time, a file named `app.db` will automatically appear in your `backend` folder. This file is your entire database and can be easily explored using SQLite visualization tools like [DB Browser for SQLite](https://sqlitebrowser.org/) if you ever want to see raw table data.
