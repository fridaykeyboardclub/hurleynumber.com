module Model exposing (..)

import Maybe exposing (withDefault)
import Round

type alias Model =
  { input : HurleyInput
  }

type alias HurleyInput =
  { keyboards : Maybe Int
  , keyboardGbs : Maybe Int
  , unmodifiedSwitchSets : Maybe Int
  , modifiedSwitchSets : Maybe Int
  , switchGbs : Maybe Int
  , keycapSets : Maybe Int
  , keycapGbs : Maybe Int
  , artisans : Maybe Int
  , artisanGbs : Maybe Int
  , deskpads : Maybe Int
  , deskpadGbs : Maybe Int
  , cables : Maybe Int
  , cableGbs : Maybe Int
  , accessories : Maybe Int
  , accessoryGbs : Maybe Int
  -- TODO other input fields
  }

type Event
  = UpdateEvent (HurleyInput -> HurleyInput)

-- Update functions for model

setKeyboards a model = { model | keyboards = a }
setKeyboardGbs a model = { model | keyboardGbs = a }
setUnmodifiedSwitchSets a model = { model | unmodifiedSwitchSets = a }
setModifiedSwitchSets a model = { model | modifiedSwitchSets = a }
setSwitchGbs a model = { model | switchGbs = a }
setKeycapSets a model = { model | modifiedSwitchSets = a }
setKeycapGbs a model = { model | keycapGbs = a }
setArtisans a model = { model | artisans = a }
setArtisanGbs a model = { model | artisanGbs = a }
setDeskpads a model = { model | deskpads = a }
setDeskpadGbs a model = { model | deskpadGbs = a }
setCables a model = { model | cables = a }
setCableGbs a model = { model | cableGbs = a }
setAccessories a model = { model | accessories = a }
setAccessoryGbs a model = { model | accessoryGbs = a }


-- Calculate the Hurley number from user input

calculate : HurleyInput -> String
calculate input =
  let
    orZero maybe = maybe |> withDefault 0 |> toFloat
    k_i = input.keyboards |> orZero
    g_k = input.keyboardGbs |> orZero
    s_u = input.unmodifiedSwitchSets |> orZero
    s_c = input.modifiedSwitchSets |> orZero
    g_s = input.switchGbs |> orZero
    c = input.keycapSets |> orZero
    g_c = input.keycapGbs |> orZero
    a = orZero input.artisans + orZero input.deskpads + orZero input.cables + orZero input.accessories
    g_a = orZero input.artisanGbs + orZero input.deskpadGbs + orZero input.cableGbs + orZero input.accessoryGbs

    keyboards = k_i + g_k
    switches = s_u + (1.5 * s_c) + g_s
    keycaps = c + g_c
    accessories = (a + g_a) / 4

    -- TODO more caluclations
    calculated = (keyboards + switches + keycaps + accessories) / 3
  in
    calculated |> Round.round 2

