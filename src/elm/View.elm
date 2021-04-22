module View exposing (view)

import Debug exposing (toString)
import Html exposing (Html, div, i, img, input, label, span, text)
import Html.Attributes exposing (attribute, class, id, src, type_)
import Html.Events exposing (onInput)
import Model exposing (..)
import Messages exposing (..)

view : Model -> Html Event
view model =
  div [ class "container" ]
    [ formula model
    , inputFields
    -- TODO
    ]

-- Html for the formula output
formula : Model -> Html Event
formula model =
  div [ id "result" ]
    [ img [ src "img/mykehead.png", id "mykehead" ] []
    -- TODO add more granular display
    , div [ id "formula" ]
      [ text ("= " ++ (calculate model.input)) ]
    ]

-- Html for user input fields
inputFields : Html Event
inputFields =
  div [ class "container" ]
    [ inputField "Keyboards" tooltip_keyboards setKeyboards
    , inputField "Keyboard group buys" tooltip_keyboard_group_buys setKeyboardGbs
    , inputField "Switch sets" tooltip_switches setSwitchSets
    , inputField "Keycaps" tooltip_keycaps setKeycapSets
    ]

inputField : String -> String -> (Maybe Int -> HurleyInput -> HurleyInput) -> Html Event
inputField name tooltip updateField =
  div []
    [ label [ ]
      [ span [ attribute "data-tooltip" tooltip] [ text name ]
      ]
    , input [ type_ "number", onInput (doInput updateField) ] []
    ]

doInput : (Maybe Int -> HurleyInput -> HurleyInput) -> String -> Event
doInput updater str =
  str |> String.toInt |> updater |> UpdateEvent