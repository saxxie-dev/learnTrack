module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.Index
import Web.View.Users.New
import Web.View.Users.Edit
import Web.View.Users.Show

import Data.Text

instance Controller UsersController where
    action UsersAction = do
        users <- query @User |> fetch
        render IndexView { .. }

    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action ShowUserAction { userId } = do
        user <- fetch userId
        render ShowView { .. }

    action EditUserAction { userId } = do
        user <- fetch userId
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        accessDeniedUnless (userId == currentUserId)
        user
            |> buildUser
            >>= ifValid \case
                Left user -> render EditView { .. }
                Right user -> do
                    hashedPass <- hashPassword (get #passwordHash user)
                    user <- user 
                        |> set #passwordHash hashedPass
                        |> updateRecord
                    setSuccessMessage "User updated"
                    redirectTo EditUserAction { .. }

    action CreateUserAction = do
        let user = newRecord @User
        user
            |> buildUser
            >>= ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    hashedPass <- hashPassword (get #passwordHash user)
                    user <- user 
                        |> set #passwordHash hashedPass
                        |> createRecord
                    setSuccessMessage "User created"
                    redirectToPath "/"

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo UsersAction

buildUser user = user
    |> fill @["email", "passwordHash", "failedLoginAttempts", "logins"]
    |> validateField #email isEmail 
    |> validateField #passwordHash (hasMinLength 8)
    |> validateIsUnique #email
