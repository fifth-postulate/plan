module Stream exposing
    ( empty, fromList, insert, withHistory
    , advance
    , isEmpty
    , toList
    , Stream
    )

{-| `Stream` provides an abstraction that allows to advance elements revisit them later.


# Build

@docs empty, fromList, insert, withHistory


# Operation

@docs advance


# Queries

@docs isEmpty


# Conversion

@docs toList

-}

import Stack exposing (Stack)


{-| The abstraction of a sequence of elements that can be revisited.
-}
type Stream a
    = Stream
        { previous : Stack a
        , current : Maybe a
        , next : List a
        }


{-| Creates an empty `Stream`.
-}
empty : Stream a
empty =
    Stream
        { previous = Stack.empty
        , current = Nothing
        , next = []
        }


{-| Creates a `Stream` with elements from a list.

The head of the list will be the current element. The tail of the list will follow the current element in order.

-}
fromList : List a -> Stream a
fromList elements =
    Stream
        { previous = Stack.empty
        , current = List.head elements
        , next =
            elements
                |> List.tail
                |> Maybe.withDefault []
        }


{-| Create a `Stream` with a populated history.
-}
withHistory : List a -> Stream a -> Stream a
withHistory history (Stream ({ previous, current, next } as stream)) =
    let
        stack =
            Stack.fromList history
    in
    Stream { stream | previous = stack }


{-| Insert an element into a stream.

The element will be placed at the end of the elements to come, unless there is no current element.

-}
insert : a -> Stream a -> Stream a
insert element (Stream ({ previous, current, next } as stream)) =
    case current of
        Nothing ->
            Stream { stream | current = Just element }

        Just _ ->
            Stream { stream | next = next ++ [ element ] }


{-| Advance the `Stream`, moving elements from next via current to previous.
-}
advance : Stream a -> Stream a
advance (Stream { previous, current, next } as stream) =
    case current of
        Nothing ->
            stream

        Just value ->
            let
                p =
                    Stack.push value previous

                c =
                    List.head next

                n =
                    next
                        |> List.tail
                        |> Maybe.withDefault []
            in
            Stream
                { previous = p
                , current = c
                , next = n
                }


{-| Determines if a `Stream` contains elements
-}
isEmpty : Stream a -> Bool
isEmpty (Stream { previous, current, next }) =
    let
        hasCurrent =
            current
                |> Maybe.map (\_ -> True)
                |> Maybe.withDefault False
    in
    Stack.isEmpty previous
        && not hasCurrent
        && List.isEmpty next


{-| Return a list of elements in the `Stream`.
-}
toList : Stream a -> List a
toList (Stream { previous, current, next }) =
    let
        prefix =
            previous
                |> Stack.toList
                |> List.reverse

        center =
            current
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        suffix =
            next
    in
    prefix ++ center ++ suffix
