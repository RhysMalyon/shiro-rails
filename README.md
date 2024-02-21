# Shiro API

A booking API developed in Ruby on Rails and authenticated with a JWT-based system using the `devise-jwt` gem.

Documentation is still WIP.

## Setup

Install gems:

```
bundle install
```

Set up your database:

```
rails db:create
rails db:migrate
```

Seed your database (Optional - includes dummy user for authentication login, as well as customers, appointments, and Japanese national holidays):

```
rails db:seed
```

## Running the project

In your terminal:

```
rails server
```
----
## Routes

### Authorization
----
#### Creating new user

<details>
 <summary><code>POST</code> <code><b>/signup</b></code></summary>

##### Overview

Registers a new user with the credentials provided in the parameters. These credentials can be used to sign in and access authorization-protected routes. A JWT Bearer token is returned in the response's `authorization` header.


##### Parameters

> | name             | type       | data type        | description          |
> |----------------|-----------|-----------------|---------------------|
> | email             | required | string              | User email           |
> | password      | required | string              | User password    |


##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `201`         | `text/plain;charset=UTF-8`        | `Signed up successfully`                                |
> | `400`         | `application/json`                | `{"code":"400","message":"User couldn't be created successfully. <current_user.errors.full_messages>"}`                            |

##### Example cURL

> ```javascript
> curl --location 'http://localhost:3001/signup' \
>       -H 'Content-Type: application/json' \
>       --data-raw '{
>           "user": {
>               "email": "test@test.com",
>               "password": "test1234"
>           }
>       }'
> ```

</details>


#### Login

<details>
 <summary><code>POST</code> <code><b>/login</b></code></summary>

##### Overview

Sign a user in using existing credentials. Returns a JWT Bearer token in the response's `authorization` header that can be used in protected routes' request headers.


##### Parameters

> | name      |  type     | data type               | description            |
> |-----------|-----------|-------------------------|------------------------|
> | email     |  required | string                  | User email             |
> | password  |  required | string                  | User password          |


##### Responses

> | http code     | content-type                      | response                                                 |
> |---------------|-----------------------------------|----------------------------------------------------------|
> | `200`         | `text/plain;charset=UTF-8`        | `Logged in successfully.`                                |
> | `401`         | `application/json`                | `{"code":"401","message":"Invalid Email or password"}`   |

##### Example cURL

> ```javascript
> curl --location 'http://localhost:3001/login' \
>       -H 'Content-Type: application/json' \
>       --data-raw '{
>           "user": {
>               "email": "test@test.com",
>               "password": "test1234"
>           }
>       }'
> ```

</details>


#### Logout

<details>
 <summary><code>DELETE</code> <code><b>/logout</b></code></summary>

##### Overview

Sign a user out of a session. Requires a valid JWT Bearer token in the request's `authorization` header (received in response headers from either <code>POST</code> <code><b>/login</b></code> or <code>POST</code> <code><b>/signup</b></code>).


##### Parameters

> None


##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | `text/plain;charset=UTF-8`        | `Logged out successfully.`                                          |
> | `401`         | `application/json`                | `{"code":"401","message":"Not authorized to access that route."}`   |

##### Example cURL

> ```javascript
> curl -L -X DELETE 'http://localhost:3001/logout' \
>      -H 'Authorization: Bearer <auth_token>' 
> ```

</details>

------------------------------------------------------------------------------------------
