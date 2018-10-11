module Stack exposing
    ( empty
    , toList
    , Stack
    )

{-| `Stack` provides an abstraction that allows elements to be pushed and popped.


# Constructor

@docs empty


# Conversion

@docs toList

-}


{-| The abstraction of a stack of elements.
-}
type Stack a
    = Stack (List a)


{-| Creates an empty `Stack`.
-}
empty : Stack a
empty =
    Stack []


{-| Returns a list of elements in the `Stack`, from top to bottom.
-}
toList : Stack a -> List a
toList (Stack elements) =
    elements
