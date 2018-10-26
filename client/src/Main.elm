port module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events as Event
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Plan exposing (ProblemDefinition, Candidate)
import Problem exposing (problemDefinition)
import SchoolOfUnderstanding
import Stream exposing (Stream)
import Url exposing (Url)


main : Program () (Model Candidate) Message
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , update = update
        , view = view viewCandidate
        , subscriptions = subscriptions
        }


init : Model Candidate
init =
    { stream = Stream.empty, problemDefinition = problemDefinition }


type alias Model a =
    { stream : Stream a
    , problemDefinition : ProblemDefinition
    }


type Message
    = DoNothing
    | Plan
    | BadResponse Http.Error
    | ReceiveCandidate Encode.Value
    | Advance
    | Retrograde


update : Message -> Model a -> ( Model a, Cmd Message )
update message model =
    case message of
        Plan ->
            let
                json =
                    Plan.encode model.problemDefinition

                body =
                    Http.jsonBody json

                decoder =
                    Decode.succeed ()

                request =
                    Http.post "/plan" body decoder

                handler response =
                    case response of
                        Ok _ ->
                            DoNothing

                        Err error ->
                            BadResponse error
            in
            ( model, Http.send handler request )

        Advance ->
            ( { model | stream = Stream.advance model.stream }, Cmd.none )

        Retrograde ->
            ( { model | stream = Stream.retrograde model.stream }, Cmd.none )

        -- TODO Handle all cases
        _ ->
            ( model, Cmd.none )


view : (Maybe a -> Html Message) -> Model a -> Html Message
view elementView model =
    Html.div []
        [ Html.div [] [ Html.button [ Event.onClick Plan ] [ Html.text "plan" ] ]
        , Html.div []
            [ Html.button [ Event.onClick Retrograde ] [ Html.text "←" ]
            , elementView (Stream.peek model.stream)
            , Html.button [ Event.onClick Advance ] [ Html.text "→" ]
            ]
        , Html.pre [] [ Html.text <| Encode.encode 2 (Plan.encode model.problemDefinition) ]
        ]


viewCandidate : Maybe Candidate -> Html Message
viewCandidate value =
    case value of
        Just aCandidate ->
            Html.span [] [ Html.text "a candidate" ]

        Nothing ->
            Html.span [] [ Html.text <| "-" ]

-- Subscriptions

port candidate : (Encode.Value -> msg) -> Sub msg

subscriptions : Model a -> Sub Message
subscriptions _ =
    candidate ReceiveCandidate
