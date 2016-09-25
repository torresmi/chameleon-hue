module App.View exposing (view)

import App.Models exposing (Model)
import Html as Html exposing (Html, div, text)
import Html.App as App
import Html.Events
import Html.Attributes exposing (href, class, style, id)
import App.Messages exposing (Msg(..))
import Material
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Options as Options
import Material.Menu as Menu
import App.Routing exposing (Route(..))


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
            , main = [ Html.div [] [ Html.text "Ready to change some lights!" ] ]
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


title : String
title =
    "Hue"


mainTabTitles : List String
mainTabTitles =
    [ "Lights"
    , "Groups"
    , "Scenes"
    , "Schedules"
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
    mainNavView model
