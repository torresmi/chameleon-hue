module App.Messages exposing (..)

import Http
import Material


type Msg
    = SelectSettings
    | SelectTab Int
    | Mdl (Material.Msg Msg)
