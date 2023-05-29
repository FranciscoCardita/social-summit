# Social Summit API Routes

This document describes the API routes available in the Social Summit project.

## Authentication Routes

### POST /api/auth/login

Logs in a user with the specified email and password.

#### Request Body

| Field    | Type   | Required | Description          |
| -------- | ------ | -------- | -------------------- |
| email    | string | Yes      | The user's email.    |
| password | string | Yes      | The user's password. |

#### Response

##### Success

If the login is successful, the server will respond with a 200 OK status code and a JSON object containing the user's token:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

##### Error

If the login fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                    | Description                                |
| ----------- | -------------------------- | ------------------------------------------ |
| 400         | Invalid email or password. | The email or password provided is invalid. |
| 500         | Internal server error.     | An internal server error occurred.         |

### POST /api/auth/logout

Logs out a user.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the logout is successful, the server will respond with a 200 OK status code and a JSON object containing a success message:

```json
{
  "message": "Logged out successfully."
}
```

##### Error

If the logout fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### POST /api/auth/register

Registers a new user with the specified information.

#### Request Body

| Field     | Type   | Required | Description           |
| --------- | ------ | -------- | --------------------- |
| name	    | string | Yes      | The user's name.      |
| email     | string | Yes      | The user's email.     |
| password  | string | Yes      | The user's password.  |
| birthDate | string | Yes      | The user's birthdate. |
| phone     | string | Yes      | The user's phone.     |

#### Response

##### Success

If the registragion is successful, the server will respond with a 200 OK status code and a JSON object containing the user's token:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

##### Error

If the registration fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                  | Description                           |
| ----------- | ------------------------ | ------------------------------------- |
| 400         | Email is already in use. | The email provided is already in use. |
| 500         | Internal server error.   | An internal server error occurred.    |

## Event Routes

### GET /api/events/:eventID

Retrieves an event by ID.

#### Request Parameters

| Field   | Type   | Required | Description          |
| ------- | ------ | -------- | -------------------- |
| eventID | string | Yes      | The ID of the event. |

#### Response

##### Success

If the event is retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the event:

```json
{
  "id": "1234567890",
  "name": "Enterro 2023",
  "startDate": 1631234567890,
  "endDate": 1631234567890,
  "location": "Universidade de Aveiro",
  "image": "base64 image",
  "type": "GENERAL_ADMISSION"
}
```

##### Error

If the get event fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                     |
| ----------- | ---------------------- | ----------------------------------------------- |
| 404         | Event not found.       | The event with the specified ID does not exist. |
| 500         | Internal server error. | An internal server error occurred.              |

### GET /api/events

Retrieves all events associated with the user.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the events are retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the events:

```json
[
  {
    "id": "1234567890",
    "name": "Enterro 2023",
    "startDate": 1631234567890,
    "endDate": 1631234567890,
    "location": "Universidade de Aveiro",
    "image": "base64 image",
    "type": "GENERAL_ADMISSION"
  },
  {
    "id": "0987654321",
    "name": "Enterro 2022",
    "startDate": 1631234567890,
    "endDate": 1631234567890,
    "location": "Universidade de Aveiro",
    "image": "base64 image",
    "type": "GENERAL_ADMISSION"
  }
]
```

##### Error

If the get events fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

## Group Routes

### GET /api/group

Retrieves the user's group.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the group is retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the group:

```json
{
  "users": [
    {
      "id": "1234567890",
      "name": "Mary"
    },
    {
      "id": "0987654321",
      "name": "John"
    }
  ],
  "notifications": [
    {
      "id": "1234567890",
      "type": "ENTERED_VENUE",
      "date": 1631234567890,
      "description": "Mary entered the venue."
    },
    {
      "id": "0987654321",
      "type": "LEFT_VENUE",
      "date": 1631234567890,
      "description": "Mary left the venue."
    }
  ]
}
```

##### Error

If the get group fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### GET /api/group/notifications

Retrieves the user's group notifications.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the notifications are retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the notifications:

```json
[
  {
    "id": "1234567890",
    "type": "ENTERED_VENUE",
    "date": 1631234567890,
    "description": "Mary entered the venue."
  },
  {
    "id": "0987654321",
    "type": "LEFT_VENUE",
    "date": 1631234567890,
    "description": "Mary left the venue."
  }
]
```

##### Error

If the get notifications fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### POST /api/group/notifications

Adds a new notification to the user's group.

#### Request Body

| Field       | Type     | Required | Description                                                   |
| ----------- | -------- | -------- | ------------------------------------------------------------- |
| type        | string   | Yes      | The type of notification (ENTERED_VENUE, LEFT_VENUE, COMING). |
| description | string   | Yes      | The description of the notification.                          |

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the notification is added successfully, the server will respond with a 200 OK status code and a JSON object containing the notification:

```json
{
  "id": "1234567890",
  "type": "ENTERED_VENUE",
  "date": 1631234567890,
  "description": "Mary entered the venue."
}
```

##### Error

If the add notification fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### GET /api/group/users

Retrieves the user's group users.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the users are retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the users:

```json
[
  {
    "id": "1234567890",
    "name": "Mary"
  },
  {
    "id": "0987654321",
    "name": "John"
  }
]
```

##### Error

If the get users fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### POST /api/group/users

Adds a new user to the user's group.

#### Request Body

| Field | Type   | Required | Description       |
| ----- | ------ | -------- | ----------------- |
| email | string | Yes      | The user's email. |

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the user is added successfully, the server will respond with a 200 OK status code and a JSON object containing a success message:

```json
{
  "message": "User added to the group."
}
```

##### Error

If the add user fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                       | Description                                                          |
| ----------- | ----------------------------- | -------------------------------------------------------------------- |
| 401         | Unauthorized.                 | The `Authorization` header is missing from the request.              |
| 401         | Invalid token.                | The `Authorization` header contains an invalid token.                | 
| 400         | Invalid user email.           | The user's email is invalid.                                         |
| 400         | User is already in the group. | The user is already in the group.                                    |
| 500         | Internal server error.        | An internal server error occurred.                                   |

### DELETE /api/group/users

Removes a user from the user's group.

#### Request Body

| Field | Type   | Required | Description  |
| ----- | ------ | -------- | ------------ |
| id    | string | Yes      | The user ID. |

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the user is removed successfully, the server will respond with a 200 OK status code and a JSON object containing a success message:

```json
{
  "message": "User removed from the group."
}
```

##### Error

If the remove user fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                       | Description                                                          |
| ----------- | ----------------------------- | -------------------------------------------------------------------- |
| 401         | Unauthorized.                 | The `Authorization` header is missing from the request.              |
| 401         | Invalid token.                | The `Authorization` header contains an invalid token.                |
| 400         | Invalid user ID.              | The user's ID is invalid.                                            |
| 400         | User is not in the group.     | The user is not in the group.                                        |
| 500         | Internal server error.        | An internal server error occurred.                                   |

## User Routes

### GET /api/users/:userID

Retrieves a user.

#### Request Parameters

| Field  | Type   | Required | Description  |
| ------ | ------ | -------- | ------------ |
| userID | string | Yes      | The user ID. |

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the user is retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the user:

```json
{
  "id": "1234567890",
  "name": "Mary",
  "email": "mary@gmail.com",
  "birthDate": 1631234567890,
  "phone": "1234567890",
  "wallet": {
    "id": "1234567890",
    "balance": 100,
    "transactions": [
      {
        "id": "1234567890",
        "date": 1631234567890,
        "amount": 50,
        "type": "TOPUP",
        "description": "Top UP."
      },
      {
        "id": "0987654321",
        "date": 1631234567890,
        "amount": 1,
        "type": "PAYMENT",
        "description": "Beer."
      }
    ]
  },
  "group": {
    "users": [
      {
        "id": "1234567890",
        "name": "Mary"
      },
      {
        "id": "0987654321",
        "name": "John"
      }
    ],
    "notifications": [
      {
        "id": "1234567890",
        "date": 1631234567890,
        "type": "PAYMENT",
        "description": "Beer."
      }
    ]
  },
  "localization": {
    "latitude": 0,
    "longitude": 0
  },
  "events": ["53622671572733952", "53622671572733953"],
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

##### Error

If the user is not found, the server will respond with a 404 Not Found status code and an error message:

| Status Code | Message                       | Description                                             |
| ----------- | ----------------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.                 | The `Authorization` header is missing from the request. |
| 401         | Invalid token.                | The `Authorization` header contains an invalid token.   |
| 401         | Unauthorized.                 | The user is not authorized to access this resource.     |
| 404         | User not found.               | The user with the specified ID was not found.           |
| 500         | Internal server error.        | An internal server error occurred.                      |

## Wallet Routes

### GET /api/wallet

Retrieves the user's wallet.

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the wallet is retrieved successfully, the server will respond with a 200 OK status code and a JSON object containing the wallet:

```json
{
  "id": "1234567890",
  "balance": 100,
  "transactions": [
    {
      "id": "1234567890",
      "date": 1631234567890,
      "amount": 50,
      "type": "TOPUP",
      "description": "Top UP."
    },
    {
      "id": "0987654321",
      "date": 1631234567890,
      "amount": 1,
      "type": "PAYMENT",
      "description": "Beer."
    }
  ]
}
```

##### Error

If the get wallet fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                | Description                                             |
| ----------- | ---------------------- | ------------------------------------------------------- |
| 401         | Unauthorized.          | The `Authorization` header is missing from the request. |
| 401         | Invalid token.         | The `Authorization` header contains an invalid token.   |
| 500         | Internal server error. | An internal server error occurred.                      |

### POST /api/wallet/transaction

Adds a new transaction to the user's wallet.

#### Request Body

| Field       | Type   | Required | Description                                     |
| ----------- | ------ | -------- | ----------------------------------------------- |
| amount      | string | Yes      | The transaction amount.                         |
| type        | string | Yes      | The transaction type (TOPUP, PAYMENT).          |
| description | string | No       | The transaction description (Only in payments). |

#### Request Headers

| Field          | Type   | Required | Description       |
| -------------- | ------ | -------- | ----------------- |
| Authorization  | string | Yes      | The user's token. |

#### Response

##### Success

If the transaction is added successfully, the server will respond with a 200 OK status code and a JSON object containing the transaction:

```json
{
  "id": "1234567890",
  "date": 1631234567890,
  "amount": 50,
  "type": "TOPUP",
  "description": "Top UP."
}
```

##### Error

If the add transaction fails, the server will respond with an appropriate error status code and an error message:

| Status Code | Message                                           | Description                                                          |
| ----------- | ------------------------------------------------- | -------------------------------------------------------------------- |
| 401         | Unauthorized.                                     | The `Authorization` header is missing from the request.              |
| 401         | Invalid token.                                    | The `Authorization` header contains an invalid token.                |
| 400         | Description is required for payment transactions. | The transaction description is missing.                              |
| 400         | Insufficient funds.                               | The user does not have enough funds to make the payment.             |
| 500         | Internal server error.                            | An internal server error occurred.                                   |