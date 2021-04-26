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
setKeycapSets a model = { model | keycapSets = a }
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
    keyboards = calculateK input |> withDefault 0
    switches = calculateS input |> withDefault 0
    keycaps = calculateC input |> withDefault 0
    accessories = calculateA input |> withDefault 0

    calculated = (keyboards + switches + keycaps + accessories) / 3
  in
    calculated |> Round.round 1

calculateK input =
  if input.keyboards == Nothing && input.keyboardGbs == Nothing then
    Nothing
  else
    let
      k_i = input.keyboards |> orZero
      g_k = input.keyboardGbs |> orZero
    in Just (k_i + g_k)

calculateS input =
  if input.unmodifiedSwitchSets == Nothing
    && input.modifiedSwitchSets == Nothing
    && input.switchGbs == Nothing then
    Nothing
  else
    let
      s_u = input.unmodifiedSwitchSets |> orZero
      s_c = input.modifiedSwitchSets |> orZero
      g_s = input.switchGbs |> orZero
    in Just (s_u + (1.5 * s_c) + g_s)

calculateC input =
  if input.keycapSets == Nothing && input.keycapGbs == Nothing then
    Nothing
  else
    let
      c = input.keycapSets |> orZero
      g_c = input.keycapGbs |> orZero
    in Just (c + g_c)

calculateA input =
  if input.artisans == Nothing && input.artisanGbs == Nothing
    && input.deskpads == Nothing && input.deskpadGbs == Nothing
    && input.cables == Nothing && input.cableGbs == Nothing
    && input.accessories == Nothing && input.accessoryGbs == Nothing then
    Nothing
  else
    let
      a = orZero input.artisans + orZero input.deskpads + orZero input.cables + orZero input.accessories
      g_a = orZero input.artisanGbs + orZero input.deskpadGbs + orZero input.cableGbs + orZero input.accessoryGbs
    in Just ((a + g_a) / 4)

orZero maybe = maybe |> withDefault 0 |> toFloat
