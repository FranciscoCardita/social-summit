# Social Summit Database Schema

This document describes the database schema for the Social Summit app.

## Event

| Field     | Type   | Description                                     |
| --------- | ------ | ----------------------------------------------- |
| id        | String | The ID of the event.                            |
| name      | String | The name of the event.                          |
| startDate | Double | The timestamp of the start date of the event.   |
| endDate   | Double | The timestamp of the end date of the event.     |
| location  | String | The location of the event.                      |
| image     | String | The base64 encoded string of the event's image. |
| type      | String | The type of the event.                          |

## User

| Field        | Type         | Description                                                                      |
| ------------ | ------------ | -------------------------------------------------------------------------------- |
| id           | String       | Unique ID of the user. An ID based on the time the user was created (Snowflake). |
| name         | String       | Name of the user.                                                                |
| email        | String       | Email of the user.                                                               |
| password     | String       | Password of the user. (Encrypted)                                                |
| birthDate    | Double       | The timestamp of the user's birth date.                                          |
| phone        | String       | The phone number of the user.                                                    |
| avatar       | String       | The base64 encoded string of the user's avatar.                                  |
| wallet       | Wallet       | The wallet of the user.                                                          |
| group        | Group        | The group of the user.                                                           |
| localization | Localization | The localization of the user.                                                    |
| events       | String[]     | The IDs of the events the user is attending.                                     |
| token        | String       | The token of the user.                                                           |

### Wallet

| Field        | Type          | Description                     |
| ------------ | ------------- | ------------------------------- |
| id           | String        | The ID of the wallet.           |
| balance      | Double        | The balance of the wallet.      |
| transactions | Transaction[] | The transactions of the wallet. |

#### Transaction

| Field       | Type   | Description                         |
| ----------- | ------ | ----------------------------------- |
| id          | String | The ID of the transaction.          |
| type        | String | The type of the transaction.        |
| date        | Double | The timestamp of the transaction.   |
| amount      | Double | The amount of the transaction.      |
| description | String | The description of the transaction. |

### Group

| Field         | Type           | Description                     |
| ------------- | -------------- | ------------------------------- |
| users         | BasicUser[]    | The users of the group.         |
| notifications | Notification[] | The notifications of the group. |

#### BasicUser

| Field  | Type   | Description                                     |
| ------ | ------ | ----------------------------------------------- |
| id     | String | The ID of the user.                             |
| name   | String | The name of the user.                           |
| avatar | String | The base64 encoded string of the user's avatar. |

#### Notification

| Field       | Type   | Description                          |
| ----------- | ------ | ------------------------------------ |
| id          | String | The ID of the notification.          |
| type        | String | The type of the notification.        |
| date        | Double | The timestamp of the notification.   |
| description | String | The description of the notification. |

### Localization

| Field     | Type   | Description                        |
| --------- | ------ | ---------------------------------  |
| latitude  | Double | The latitude of the localization.  |
| longitude | Double | The longitude of the localization. |