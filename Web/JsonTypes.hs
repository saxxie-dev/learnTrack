{-# language DeriveAnyClass #-}

module Web.JsonTypes where

import Generated.Types
import IHP.ControllerPrelude
import qualified Data.Aeson as Aeson
import GHC.Generics (Generic)
import qualified Generics.SOP as SOP
import Language.Haskell.To.Elm
import Application.Lib.DerivingViaElm ( ElmType(..) )

-- JSON serializable types and functions
-- for exposing IHP data to Elm and JSON responses

data TrackJSON = TrackJSON
  { id :: Text
  , name :: Text
  } deriving ( Generic
             , SOP.Generic
             , SOP.HasDatatypeInfo
             )
    deriving ( Aeson.ToJSON
             , Aeson.FromJSON
             , HasElmType
             , HasElmDecoder Aeson.Value
             , HasElmEncoder Aeson.Value)
    via ElmType "Api.Generated.Track" TrackJSON

trackToJSON :: Track -> TrackJSON
trackToJSON track =
    TrackJSON {
        id = show track.id,
        name = track.name
    }
