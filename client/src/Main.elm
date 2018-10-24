module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events as Event
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Plan exposing (ProblemDefinition)
import Problem exposing (problemDefinition)
import SchoolOfUnderstanding
import Stream exposing (Stream)
import Url exposing (Url)


main : Program () (Model Int) Message
main =
    Browser.element
        { init = \_ -> ( init <| List.range 1 10, Cmd.none )
        , update = update
        , view = view viewInt
        , subscriptions = \_ -> Sub.none
        }


init : List a -> Model a
init list =
    { stream = Stream.fromList list, problemDefinition = problemDefinition }


type alias Model a =
    { stream : Stream a
    , problemDefinition : ProblemDefinition
    }


type Message
    = DoNothing
    | Plan
    | BadResponse Http.Error
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


viewInt : Maybe Int -> Html Message
viewInt value =
    case value of
        Just n ->
            Html.span [] [ Html.text <| String.fromInt n ]

        Nothing ->
            Html.span [] [ Html.text <| "-" ]
