module Main exposing (..)

import Model exposing (Model)
import Messages exposing (Msg(..))
import Update exposing (update)
import Commands
import View exposing (view)
import Material
import Routing
import Navigation
import Ports


init : Result String Routing.Route -> ( Model, Cmd Msg )
init result =
    let
        commands =
            Cmd.batch
                [ Commands.nupnpSearch
                , Material.init Mdl
                ]

        currentRoute =
            Routing.routeFromResult result
    in
        ( Model.new currentRoute, commands )


urlUpdate : Result String Routing.Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( { model | route = currentRoute }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.storageInput StoredUserName
        , Material.subscriptions Mdl model
        ]



-- Main


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
