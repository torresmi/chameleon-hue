module View exposing (..)

import Models exposing (Model, IpAddress)
import Html as Html exposing (Html, div, text)
import Html.App as App
import Html.Events
import Html.Attributes exposing (href, class, style, id)
import Messages exposing (Msg(..))
import Auth.Views exposing (view)
import Auth.Models
import Material
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Options as Options
import Material.Menu as Menu
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    div
        []
        [ page model ]


mainNavView : Model -> Html Msg
mainNavView model =
    --TODO: Just for prototyping. Add css manually
    Material.Scheme.topWithScheme Color.DeepPurple Color.Cyan <|
        Layout.render Mdl
            model.mdl
            [ Layout.waterfall False
            , Layout.fixedHeader
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = header model
            , drawer = []
            , tabs = (tabs mainTabTitles model)
            , main = [ settingsView model ]
            }


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        []
        [ Layout.title [] [ text title ]
        , Layout.spacer
        , Menu.render Mdl
            [ settingsIndex ]
            model.mdl
            [ Menu.bottomRight
            , Menu.ripple
            , Options.css "margin-bottom" "2px"
            ]
            [ Menu.item
                [ Menu.onSelect SelectSettings ]
                [ text "Settings" ]
            ]
        ]
    ]


settingsIndex : Int
settingsIndex =
    0


settingsView : Model -> Html Msg
settingsView model =
    App.map AuthMsg (Auth.Views.view model.ipAddress model.authStatus)


title : String
title =
    "Hue"


mainTabTitles : List String
mainTabTitles =
    [ "Lights"
    ]


tabs : List String -> Model -> ( List (Html Msg), List (Options.Style Msg) )
tabs titles model =
    let
        tabTitles =
            List.map
                (\title ->
                    Options.span [] [ text title ]
                )
                titles

        tabOptions =
            []
    in
        ( tabTitles, tabOptions )


page : Model -> Html Msg
page model =
    let
        needAuth =
            model.authStatus == Auth.Models.NeedAuth
    in
        case ( model.route, needAuth ) of
            ( SettingsRoute, _ ) ->
                settingsView model

            ( MainNavRoute, False ) ->
                mainNavView model

            ( MainNavRoute, True ) ->
                settingsView model

            ( NotFoundRoute, _ ) ->
                notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not Found" ]
