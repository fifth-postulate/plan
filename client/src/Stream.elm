module Stream exposing
    ( empty, fromList
    , toList
    , Stream
    )

{-| `Stream` provides an abstraction that allows to advance elements revisit them later.


# Constructor

@docs empty, fromList


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
