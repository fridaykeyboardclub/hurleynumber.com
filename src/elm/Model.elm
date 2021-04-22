module Model exposing (..)

import Maybe exposing (withDefault)
import Round

type alias Model =
  { input : HurleyInput
  }

type alias HurleyInput =
  { keyboards : Maybe Int
  , keyboardGbs : Maybe Int
  , switchSets : Maybe Int
  , keycapSets : Maybe Int
  -- TODO other input fields
  }

type Event
  = UpdateEvent (HurleyInput -> HurleyInput)

-- Update functions for model

setKeyboards a model = { model | keyboards = a }
setKeyboardGbs a model = { model | keyboardGbs = a }
setSwitchSets a model = { model | switchSets = a }
setKeycapSets a model = { model | keycapSets = a }

-- Calculate the Hurley number from user input

calculate : HurleyInput -> String
calculate input =
  let
    defaulting maybe = maybe |> withDefault 0 |> toFloat
    k_i = defaulting input.keyboards
    g_k = defaulting input.keyboardGbs
    s_u = defaulting input.switchSets
    c = defaulting input.keycapSets

    -- TODO more caluclations
    calculated = (k_i + g_k + s_u + c) / 3
  in
    calculated |> Round.round 2

