module Stream exposing
    ( empty
    , toList
    , Stream
    )

{-| `Stream` provides an abstraction that allows to advance elements revisit them later.


# Constructor

@docs empty

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
    Stream { previous = Stack.empty
    , current = Nothing
    , next = []
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
