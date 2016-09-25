module View exposing (view)

import Models exposing (Model)
import Messages exposing (Msg(..))
import Html exposing (Html, div, text)
import Html.App
import Auth.Models as AuthModel
import Routing exposing (Route(..))
import App.View
import Auth.CreateUser


view : Model -> Html Msg
view model =
    div
        []
        [ page model ]


page : Model -> Html Msg
page model =
    let
        needAuth =
            model.authStatus == AuthModel.NeedAuth

        showHueView =
            Html.App.map Messages.App (App.View.view model.appModel)

        showCreateUserView =
            let
                context =
                    Models.AuthContext model.ipStatus model.authStatus
            in
                Html.App.map CreateUser (Auth.CreateUser.view context)
    in
        case ( model.route, needAuth ) of
            ( Login, False ) ->
                showHueView

            ( Login, True ) ->
                showCreateUserView

            ( NotFound, _ ) ->
                notFoundView

            ( Routing.App _, True ) ->
                showCreateUserView

            ( Routing.App _, False ) ->
                showHueView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not Found" ]
