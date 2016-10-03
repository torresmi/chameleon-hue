module Auth.Commands exposing (createUser, deleteUser, createUserResponseDecoder, deleteUserResponseDecoder)

import Http
import Json.Decode as Decode exposing ((:=))
import Task exposing (Task)
import Auth.Messages exposing (Msg(..))
import Auth.Types exposing (Error, Response(..))
import Types exposing (IpAddress)


createUser : IpAddress -> String -> Cmd Msg
createUser ipAddress deviceType =
    let
        url =
            baseUrl ipAddress

        body deviceType =
            Http.string ("{\"devicetype\": \"" ++ deviceType ++ "\"}")
    in
        Http.post createUserResponseDecoder url (body deviceType)
            |> Task.perform CreateUserFail CreateUserSuccess


deleteUser : IpAddress -> Types.Username -> Cmd Msg
deleteUser ipAddress userName =
    Http.fromJson deleteUserResponseDecoder
        (Http.send
            Http.defaultSettings
            { verb = "DELETE"
            , headers = [ jsonHeaderType ]
            , url = (baseUrl ipAddress ++ "/" ++ userName ++ "/config/whitelist/" ++ userName)
            , body = Http.empty
            }
        )
        |> Task.perform DeleteUserFail DeleteUserSuccess


jsonHeaderType : ( String, String )
jsonHeaderType =
    ( "Content-Type", "application/json" )


baseUrl : IpAddress -> String
baseUrl ipAddress =
    "http://" ++ ipAddress ++ "/api"



-- Decoding


responseDecoder : Decode.Decoder a -> Decode.Decoder (Response a)
responseDecoder responseDecoder =
    Decode.oneOf
        [ Decode.map ValidResponse responseDecoder
        , Decode.map ErrorsResponse errorsDecoder
        ]


userSuccessDecoder : Decode.Decoder String
userSuccessDecoder =
    Decode.list (Decode.at [ "success", "username" ] Decode.string)
        `Decode.andThen` takeFirst


createUserResponseDecoder : Decode.Decoder (Response String)
createUserResponseDecoder =
    responseDecoder userSuccessDecoder


userDeleteSuccess : Decode.Decoder String
userDeleteSuccess =
    Decode.list ("success" := Decode.string)
        `Decode.andThen` takeFirst


takeFirst : List a -> Decode.Decoder a
takeFirst values =
    let
        head =
            List.head values
    in
        case head of
            Just value ->
                Decode.succeed value

            Nothing ->
                Decode.fail "List was empty"


deleteUserResponseDecoder : Decode.Decoder (Response String)
deleteUserResponseDecoder =
    responseDecoder userDeleteSuccess


errorDecoder : Decode.Decoder Error
errorDecoder =
    Decode.at [ "error" ] <|
        Decode.object3
            Error
            ("type" := Decode.int)
            ("address" := Decode.string)
            ("description" := Decode.string)


errorsDecoder : Decode.Decoder (List Error)
errorsDecoder =
    Decode.list errorDecoder
