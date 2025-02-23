module Common exposing (Msg(..), Model, PartnerSummary, PartnerIndex, Page(..))

import Browser
import Url
import Browser.Navigation as Nav
import Http
import Time

type Page
  = Root
  | NotFound

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | GotPartnersForIndex (Result Http.Error PartnerIndex)

type alias Model = 
  { navKey : Nav.Key
  , page: Page
  , partnerData: PartnerIndex
  }

type alias PartnerSummary =
  { id: Int
  , name: String
  , summary: String
  , ceatedAt: String -- Time.Posix
  }

type alias PartnerIndex =
  { partners: List PartnerSummary
  , count: Int
  }
