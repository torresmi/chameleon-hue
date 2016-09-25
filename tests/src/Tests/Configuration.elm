module Tests.Configuration exposing (tests)

import Tests.Utils exposing (testDecoder)
import ElmTest exposing (..)
import Resource.Configuration exposing (..)
import Auth.CreateUser as CreateUser
import Auth.DeleteUser as DeleteUser


tests : Test
tests =
    suite "User decoders"
        [ test "Create user success" <|
            testDecoder CreateUser.createUserResponseDecoder createUserSuccess
        , test "Create user failure. Need to push link button" <|
            testDecoder CreateUser.createUserResponseDecoder createUserLinkFailure
        , test "Delete user success" <|
            testDecoder DeleteUser.deleteUserResponseDecoder deleteUserSuccess
        , test "Delete user failure. General error" <|
            testDecoder DeleteUser.deleteUserResponseDecoder deleteUserFailure
        ]
