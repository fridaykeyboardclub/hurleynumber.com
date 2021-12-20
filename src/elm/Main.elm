module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Platform.Cmd exposing (map)
import View exposing (view)
import Model exposing (Model, Event(..))

--
-- INIT
--

init : {} -> ( Model, Cmd Event )
init _ =
  let
    model =
      { input =
        { keyboards = Nothing
        , keyboardGbs = Nothing
        , macropads = Nothing
        , macropadGbs = Nothing
        , switchSets = Nothing
        , modifiedSwitchSets = Nothing
        , switchGbs = Nothing
        , keycapSets = Nothing
        , keycapGbs = Nothing
        , noveltyKits = Nothing
        , noveltyKitsGbs = Nothing
        , artisans = Nothing
        , artisanGbs = Nothing
        , deskpads = Nothing
        , deskpadGbs = Nothing
        , cables = Nothing
        , cableGbs = Nothing
        , accessories = Nothing
        , accessoryGbs = Nothing
        }
      }
  in
    ( model, Cmd.none )

--
-- Update
--

update : Event -> Model -> ( Model, Cmd Event )
update event model =
  case event of
    UpdateEvent f ->
      let
        updated_input = { model | input = f model.input }
      in (updated_input, Cmd.none)

--
-- MAIN
--

main : Program {} Model Event
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
