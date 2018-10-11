module Stack exposing
    ( empty, fromList
    , push
    , isEmpty
    , toList
    , Stack
    )

{-| `Stack` provides an abstraction that allows elements to be pushed and popped.


# Constructor

@docs empty, fromList


# Operation

@docs push


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


{-| Create an `Stack` from a list.

The elements of the list will be inserted from left to right. This means that the head will and up on hte bottom of the stack.

-}
fromList : List a -> Stack a
fromList elements =
    elements
        |> List.reverse
        |> Stack


{-| Pushes an element onto the `Stack`.
-}
push : a -> Stack a -> Stack a
push head (Stack tail) =
    Stack (head :: tail)


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
