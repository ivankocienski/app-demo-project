module Api exposing (readPostsIndex)

import Http
import Json.Decode as JD
import Common exposing (Msg(..), PartnerSummary, PartnerIndex)

endPoint: String
endPoint = "http://localhost:8002/api/v1"

readPostsIndex: Cmd Msg
readPostsIndex =
  Http.get 
  { url = (endPoint ++ "/partners")
  , expect = Http.expectJson GotPartnersForIndex partnerIndexDecoder
  }

partnerSummaryDecoder: JD.Decoder PartnerSummary
partnerSummaryDecoder =
  JD.map4 PartnerSummary
    (JD.field "id" JD.int)
    (JD.field "name" JD.string)
    (JD.field "summary" JD.string)
    (JD.field "created_at" JD.string) --JD.Extra.datetime)

partnerIndexDecoder: JD.Decoder PartnerIndex
partnerIndexDecoder =
  JD.map2 PartnerIndex
    (JD.field "partners" (JD.list partnerSummaryDecoder))
    (JD.field "partner_count" JD.int)

