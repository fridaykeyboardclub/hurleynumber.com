module View exposing (view)

import Html exposing (Html, div, h2, i, img, input, label, span, table, td, text, tr)
import Html.Attributes exposing (attribute, class, id, src, type_)
import Html.Events exposing (onInput)
import Model exposing (..)
import Messages exposing (..)
import String exposing (fromFloat)

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
    -- TODO add more granular display
    [ div [ id "formula" ]
      [ div [ id "formula-head-part", class "formula-part" ]
        [ img [ src "img/mykehead.png", id "mykehead" ] []
        , text "="
        ]
      , div [ id "formula-fraction-part", class "formula-part" ]
        [ div [ id "formula-fraction-top" ]
          [ formulaNumber "K" "Keyboards" (calculateK model.input)
          , text " + "
          , formulaNumber "S" "Switches" (calculateS model.input)
          , text " + "
          , formulaNumber "C" "Keycaps" (calculateC model.input)
          , text " + "
          , formulaNumber "A" "Accessories / 4" (calculateA model.input)
          ]
        , div [ id "formula-fraction-bottom", class "formula-part" ] [ text "3" ]
        ]
      , div [ id "formula-result-part", class "formula-part" ]
        [ text ("= " ++ calculate model.input) ]
      ]
    ]

formulaNumber : String -> String -> Maybe Float -> Html Event
formulaNumber name altText maybeNumber =
  let
    content =
      case maybeNumber of
        Just number ->  text (fromFloat number)
        Nothing -> text name
  in span [ class "has-tooltip-multiline", attribute "data-tooltip" altText ] [ content ]

-- Html for user input fields
inputFields : Html Event
inputFields =
  div []
    [ div [ class "columns is-desktop is-multiline input-group" ]
      [ div [ class "column is-half" ]
        [ h2 [ class "inputtitle" ] [ text "K: Keyboards" ]
        , table []
          [ inputField "Keyboards" tooltip_keyboards setKeyboards
          , inputField "Keyboard group buys" tooltip_keyboard_gbs setKeyboardGbs
          , inputField "Macropads" tooltip_macropads setMacropads
          , inputField "Macropad group buys" tooltip_macropad_gbs setMacropadGbs
          ]
        ]
      , div [ class "column is-half" ]
        [ h2 [ class "inputtitle" ] [ text "S: Switches" ]
        , table []
          [ inputField "Switch sets (unmodified)" tooltip_unmodified_switches setUnmodifiedSwitchSets
          , inputField "Switch sets (modified)" tooltip_modified_switches setModifiedSwitchSets
          , inputField "Switch group buys" tooltip_switch_gbs setSwitchGbs
          ]
        ]
      ]
    , div [ class "columns is-desktop is-multiline input-group" ]
      [ div [ class "column is-half" ]
        [ h2 [ class "inputtitle" ] [ text "C: Keycaps" ]
        , table []
          [ inputField "Keycaps" tooltip_keycaps setKeycapSets
          , inputField "Keycap group buys" tooltip_keycap_gbs setKeycapGbs
          ]
        ]
      , div [ class "column is-half" ]
        [ h2 [ class "inputtitle" ] [ text "A: Accessories / 4" ]
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
      ]
    ]


inputField : String -> String -> (Maybe Int -> HurleyInput -> HurleyInput) -> Html Event
inputField name tooltip updateField =
  let
    tooltipList = if tooltip == "" then [] else [ attribute "data-tooltip" tooltip, class "has-tooltip-multiline" ]
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