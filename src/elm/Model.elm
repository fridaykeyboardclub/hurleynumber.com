module Model exposing (..)

import Maybe exposing (withDefault)
import Round

type alias Model =
  { input : HurleyInput
  }

type alias HurleyInput =
  { keyboards : Maybe Int
  , keyboardGbs : Maybe Int
  , macropads : Maybe Int
  , macropadGbs : Maybe Int
  , designed : Maybe Int
  , switchSets : Maybe Int
  , modifiedSwitchSets : Maybe Int
  , switchGbs : Maybe Int
  , keycapSets : Maybe Int
  , keycapGbs : Maybe Int
  , noveltyKits : Maybe Int
  , noveltyKitsGbs : Maybe Int
  , artisans : Maybe Int
  , artisanGbs : Maybe Int
  , deskpads : Maybe Int
  , deskpadGbs : Maybe Int
  , cables : Maybe Int
  , cableGbs : Maybe Int
  , accessories : Maybe Int
  , accessoryGbs : Maybe Int
  , merch : Maybe Int
  , merchGbs : Maybe Int
  -- TODO other input fields
  }

type alias HurleyOutput =
  { number : String
  , sigma : String
  , coreIndex : String
  }

type Event
  = UpdateEvent (HurleyInput -> HurleyInput)

-- Update functions for model

setKeyboards a model = { model | keyboards = a }
setKeyboardGbs a model = { model | keyboardGbs = a }
setMacropads a model = { model | macropads = a }
setMacropadGbs a model = { model | macropadGbs = a }
setDesigned a model = { model | designed = a }
setSwitchSets a model = { model | switchSets = a }
setModifiedSwitchSets a model = { model | modifiedSwitchSets = a }
setSwitchGbs a model = { model | switchGbs = a }
setKeycapSets a model = { model | keycapSets = a }
setKeycapGbs a model = { model | keycapGbs = a }
setNoveltyKits a model = { model | noveltyKits = a }
setNoveltyKitsGbs a model = { model | noveltyKitsGbs = a }
setArtisans a model = { model | artisans = a }
setArtisanGbs a model = { model | artisanGbs = a }
setDeskpads a model = { model | deskpads = a }
setDeskpadGbs a model = { model | deskpadGbs = a }
setCables a model = { model | cables = a }
setCableGbs a model = { model | cableGbs = a }
setAccessories a model = { model | accessories = a }
setAccessoryGbs a model = { model | accessoryGbs = a }
setMerch a model = { model | merch = a }
setMerchGbs a model = { model | merchGbs = a }

-- Calculate the Hurley number from user input

calculate : HurleyInput -> HurleyOutput
calculate input =
  let
    keyboards = calculateK input |> withDefault 0
    switches = calculateS input |> withDefault 0
    keycaps = calculateC input |> withDefault 0
    accessories = calculateA input |> withDefault 0

    -- Bonuses for switch modification and designed keyboards do not count for the core index or sigma
    coreSwitches =
      ((input.switchSets |> withDefault 0)
      + (input.switchGbs |> withDefault 0)
      ) |> toFloat
    coreKeyboards =
      ((input.keyboards |> withDefault 0)
      + (input.keyboardGbs |> withDefault 0)
      + (input.macropads |> withDefault 0)
      + (input.macropadGbs |> withDefault 0)
      ) |> toFloat

    -- Sigma calculation
    sigmaAvg = (keyboards + coreSwitches + keycaps) / 3
    variance =
      ((keyboards - sigmaAvg) ^ 2
      + (coreSwitches - sigmaAvg) ^ 2
      + (keycaps - sigmaAvg) ^ 2
      ) / 3
    sigma = sqrt variance

    --
    coreIndex = (coreKeyboards + coreSwitches + keycaps) / 3

    calculated = (keyboards + switches + keycaps + accessories) / 3
  in
    { number = calculated |> Round.round 2
    , sigma = sigma |> Round.round 2
    , coreIndex = coreIndex |> Round.round 2
    }

calculateK input =
  if input.keyboards == Nothing && input.keyboardGbs == Nothing
    && input.macropads == Nothing && input.macropadGbs == Nothing
    && input.designed == Nothing then
    Nothing
  else
    let
      k_i = input.keyboards |> orZero
      g_k = input.keyboardGbs |> orZero
      k_m = input.macropads |> orZero
      g_m = input.macropadGbs |> orZero
      k_d = input.designed |> orZero
    in Just (k_i + g_k + k_m + g_m + (k_d / 2))

calculateS input =
  if input.switchSets == Nothing
    && input.modifiedSwitchSets == Nothing
    && input.switchGbs == Nothing then
    Nothing
  else
    let
      s_u = input.switchSets |> orZero
      s_c = input.modifiedSwitchSets |> orZero
      g_s = input.switchGbs |> orZero
    in Just (s_u + (0.5 * s_c) + g_s)

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
    && input.accessories == Nothing && input.accessoryGbs == Nothing
    && input.noveltyKits == Nothing && input.noveltyKitsGbs == Nothing
    && input.merch == Nothing && input.merchGbs == Nothing then
    Nothing
  else
    let
      a = orZero input.artisans + orZero input.deskpads + orZero input.cables + orZero input.accessories + orZero input.noveltyKits + orZero input.merch
      g_a = orZero input.artisanGbs + orZero input.deskpadGbs + orZero input.cableGbs + orZero input.accessoryGbs + orZero input.noveltyKitsGbs + orZero input.merchGbs
    in Just ((a + g_a) / 4)

orZero maybe = maybe |> withDefault 0 |> toFloat
