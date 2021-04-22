module View exposing (view)

import Html exposing (Html, div, h2, i, img, input, label, span, table, td, text, tr)
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
  div [ class "container", id "input" ]
    [ h2 [ class "inputtitle" ] [ text "Keyboards" ]
    , table []
      [ inputField "Keyboards" tooltip_keyboards setKeyboards
      , inputField "Keyboard group buys" tooltip_keyboard_gbs setKeyboardGbs
      ]
    , h2 [ class "inputtitle" ] [ text "Switches" ]
    , table []
      [ inputField "Switch sets (unmodified)" tooltip_unmodified_switches setUnmodifiedSwitchSets
      , inputField "Switch sets (modified)" tooltip_modified_switches setModifiedSwitchSets
      , inputField "Switch group buys" tooltip_switch_gbs setSwitchGbs
      ]
    , h2 [ class "inputtitle" ] [ text "Keycaps" ]
    , table []
      [ inputField "Keycaps" tooltip_keycaps setKeycapSets
      , inputField "Keycap group buys" tooltip_keycap_gbs setKeycapGbs
      ]
    , h2 [ class "inputtitle" ] [ text "Accessories" ]
    , table []
      [ inputField "Artisans" tooltip_artisans setArtisans
      , inputField "Artisan group buys" tooltip_artisan_gbs setArtisanGbs
      , inputField "Deskpads" tooltip_deskpads setDeskpads
      , inputField "Deskpad group buys" tooltip_deskpad_gbs setDeskpadGbs
      , inputField "Cables" tooltip_cables setCables
      , inputField "Cable group buys" tooltip_cable_gbs setCableGbs
      , inputField "Other accessories" tooltip_accessories setAccessories
      , inputField "Other accessory group buys" tooltip_accessory_gbs setAccessoryGbs
      ]
    ]


inputField : String -> String -> (Maybe Int -> HurleyInput -> HurleyInput) -> Html Event
inputField name tooltip updateField =
  let
    tooltipList = if tooltip == "" then [] else [ attribute "data-tooltip" tooltip ]
  in
    tr [ class "inputrow" ]
      [ td [] [
          label [ ]
            [ span tooltipList [ text name ]
            ]
          ]
      , td []
          [ input [ type_ "number", onInput (doInput updateField) ] []
          ]
      ]

doInput : (Maybe Int -> HurleyInput -> HurleyInput) -> String -> Event
doInput updater str =
  str |> String.toInt |> updater |> UpdateEvent