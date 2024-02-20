
# Shiro API

### Authorization
----
#### Creating new user

<details>
 <summary><code>POST</code> <code><b>/signup</b></code></summary>

##### Overview

Registers a new user with the credentials provided in the parameters. These credentials can be used to sign in and access authorization-protected routes. A JWT Bearer token is returned in the response's `authorization` header.


##### Parameters

> | name      |  type     | data type               | description                                                           |
> |-----------|-----------|-------------------------|-----------------------------------------------------------------------|
> | email      |  required | string   | User email  |
> | password      |  required | string   | User password  |


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
>               "email": "test1@test.com",
>               "password": "test1234"
>           }
>       }'
> ```

</details>

------------------------------------------------------------------------------------------
