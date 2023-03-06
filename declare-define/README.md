# Declare & Define macros

Macros that make it easier and more explicit to forward-declare
and define them later, making them immutable afterwards.

## Why?

[Fennel from Clojure](https://fennel-lang.org/from-clojure#dynamic-scope)
guide mentions that you can use `var` for forward declarations of variables.
```fennel
(var f nil)
(fn g [x]
  (when (< 0 x) (f (- x 1))))
(set f (fn [x]
  (when (< 0 x) (g (- x 1)))))
```

There is one problem with this approach: `f` remains variable and still can be changed.
You can shadow `f` with `local` after setting, of course.
```fennel
(local f f)
```

`declare` and `define` macros do just that but make this process more explicit
and make declared/defined variable local automatically, so you can not forget
it.
```fennel
(declare f)
(fn g [x]
  (when (< 0 x) (f (- x 1))))
(define f
  (fn [x]
    (when (< 0 x) (g (- x 1)))))
;; (set f 1) ; causes compilation error
```
