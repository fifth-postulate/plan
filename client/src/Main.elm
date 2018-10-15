module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events as Event
import Json.Encode as Encode
import Plan
import Problem exposing (problemDefinition)
import SchoolOfUnderstanding
import Stream exposing (Stream)


main =
    Browser.sandbox
        { init = init <| List.range 1 10
        , update = update
        , view = view viewInt
        }


init : List a -> Model a
init list =
    { stream = Stream.fromList list }


type alias Model a =
    { stream : Stream a
    }


type Message
    = Advance
    | Retrograde


update : Message -> Model a -> Model a
update message model =
    case message of
        Advance ->
            { model | stream = Stream.advance model.stream }

        Retrograde ->
            { model | stream = Stream.retrograde model.stream }


view : (Maybe a -> Html Message) -> Model a -> Html Message
view elementView model =
    Html.div []
        [ Html.div []
            [ Html.button [ Event.onClick Retrograde ] [ Html.text "←" ]
            , elementView (Stream.peek model.stream)
            , Html.button [ Event.onClick Advance ] [ Html.text "→" ]
            ]
        , Html.pre [] [ Html.text <| Encode.encode 2 (Plan.encode problemDefinition) ]
        ]


viewInt : Maybe Int -> Html Message
viewInt value =
    case value of
        Just n ->
            Html.span [] [ Html.text <| String.fromInt n ]

        Nothing ->
            Html.span [] [ Html.text <| "-" ]
