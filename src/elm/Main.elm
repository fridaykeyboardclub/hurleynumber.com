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
        , switchSets = Nothing
        , keycapSets = Nothing
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
