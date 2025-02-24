module Common exposing (Model, Msg(..), Page(..), PartnerFull, PartnerIndex, PartnerShow(..), PartnerSummary)

import Browser
import Browser.Navigation as Nav
import Http
import Time
import Url


type Page
    = Root
    | ShowPartner Int
    | NotFound


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotPartnersForIndex (Result Http.Error PartnerIndex)
    | GotPartnerForShow (Result Http.Error PartnerFull)


type PartnerShow
    = Empty
      -- | Loading
    | Problem String
    | Loaded PartnerFull


type alias Model =
    { navKey : Nav.Key
    , page : Page
    , partnerData : PartnerIndex
    , showPartner : PartnerShow
    }


type alias PartnerSummary =
    { id : Int
    , name : String
    , summary : String
    , createdAt : String -- Time.Posix
    }


type alias PartnerFull =
    { id : Int
    , name : String
    , summary : String
    , description : String
    , createdAt : String -- Time.Posix
    , contactEmail : String
    }


type alias PartnerIndex =
    { partners : List PartnerSummary
    , count : Int
    }
