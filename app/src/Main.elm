module Main exposing (..)

import Models
import Messages exposing (Msg(..))
import Update exposing (update)
import Commands
import View exposing (view)
import Material
import Routing
import Navigation
import Ports


init : Result String Routing.Route -> ( Models.Model, Cmd Msg )
init route =
    let
        commands =
            Cmd.batch
                [ Commands.nupnpSearch
                , Material.init Mdl
                ]

        currentRoute =
            Routing.routeFromResult route
    in
        ( Models.new currentRoute, commands )


urlUpdate : Result String Routing.Route -> Models.Model -> ( Models.Model, Cmd Msg )
urlUpdate result model =
    let
        desiredRoute =
            Routing.routeFromResult result
    in
        ( { model | route = desiredRoute }, Cmd.none )



-- Subscriptions


subscriptions : Models.Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.storageInput StoredUserName
        , Material.subscriptions Messages.Mdl model
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
