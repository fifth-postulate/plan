module Stack exposing
    ( empty
    , isEmpty
    , toList
    , Stack
    )

{-| `Stack` provides an abstraction that allows elements to be pushed and popped.


# Constructor

@docs empty


# Queries

@docs isEmpty


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


{-| Determines if a `Stack` contains elements.
-}
isEmpty : Stack a -> Bool
isEmpty (Stack elements) =
    List.isEmpty elements


{-| Returns a list of elements in the `Stack`, from top to bottom.
-}
toList : Stack a -> List a
toList (Stack elements) =
    elements
