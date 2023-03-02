# Splicing macro

**WIP**

Macro that enables splicing multi-values even when not at the last position in list/sequence/table.

## Why?

There already exists functions like `table.unpack` or `values`, but they only work at the end of surrounding table.
Sometimes, mostly in macros, you want to surround multiple forms, e.g. you want `some-macro`
```fennel
(some-macro
  form1
  form2)
```
to generate code like this
```fennel
(fn []
  (print "before")
  form1
  form2
  (print "after"))
```
If you tried to write `some-macro` like
```fennel
(fn some-macro [...]
  `(fn []
     (print "before")
     ,(values ...) ; or ,... ; or ,(table.unpack [...])
     (print "after")))
```
it would generate
```fennel
(fn []
  (print "before")
  form1 ; form2 is lost!
  (print "after"))
```
