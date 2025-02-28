module Api exposing (httpErrorDescription, readPost, readPostsIndex)

import Common exposing (Msg(..), PartnerFull, PartnerIndex, PartnerSummary)
import Config exposing (endPoint)
import Http
import Json.Decode as JD
import Json.Decode.Extra as JDX


readPostsIndex : Cmd Msg
readPostsIndex =
    Http.get
        { url = endPoint ++ "/partners"
        , expect = Http.expectJson GotPartnersForIndex partnerIndexDecoder
        }


readPost : Int -> Cmd Msg
readPost id =
    Http.get
        { url = endPoint ++ "/partners/" ++ String.fromInt id
        , expect = Http.expectJson GotPartnerForShow partnerDecoder
        }


partnerDecoder : JD.Decoder PartnerFull
partnerDecoder =
    JD.map6 PartnerFull
        (JD.field "id" JD.int)
        (JD.field "name" JD.string)
        (JD.field "summary" JD.string)
        (JD.field "description" JD.string)
        (JD.field "created_at" JDX.datetime)
        (JD.field "contact_email" JD.string)


partnerSummaryDecoder : JD.Decoder PartnerSummary
partnerSummaryDecoder =
    JD.map4 PartnerSummary
        (JD.field "id" JD.int)
        (JD.field "name" JD.string)
        (JD.field "summary" JD.string)
        (JD.field "created_at" JDX.datetime)



--JD.Extra.datetime)


partnerIndexDecoder : JD.Decoder PartnerIndex
partnerIndexDecoder =
    JD.map2 PartnerIndex
        (JD.field "partners" (JD.list partnerSummaryDecoder))
        (JD.field "partner_count" JD.int)


httpErrorDescription : Http.Error -> String
httpErrorDescription error =
    case error of
        Http.BadUrl problem ->
            "Bad URL: " ++ problem

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus code ->
            "Bad status (" ++ String.fromInt code ++ ")"

        Http.BadBody problem ->
            "Bad body: " ++ problem
