module Main exposing (..)

import Html.App
import Models exposing (..)
import Messages exposing (Msg(..))
import Update exposing (update)
import Commands
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( Models.new, Commands.nupnpSearch )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
