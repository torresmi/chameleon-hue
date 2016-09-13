module Auth.Commands exposing (createUser)

import Http
import Json.Decode as Decode exposing ((:=))
import Task exposing (Task)
import Auth.Messages exposing (Msg(..))
import Auth.Models exposing (Error, Response(..))
import Models exposing (IpAddress)


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


deleteUser : IpAddress -> String -> Cmd Msg
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


createUserDecoder : Decode.Decoder String
createUserDecoder =
    Decode.at [ "success", "deviceType" ] Decode.string


deleteUserDecoder : Decode.Decoder String
deleteUserDecoder =
    ("success" := Decode.string)


createUserResponseDecoder : Decode.Decoder (Response String)
createUserResponseDecoder =
    responseDecoder createUserDecoder


deleteUserResponseDecoder : Decode.Decoder (Response String)
deleteUserResponseDecoder =
    responseDecoder deleteUserDecoder


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
