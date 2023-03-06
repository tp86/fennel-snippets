(import-macros {: test} :tester)
(local lu (require :luaunit))

(import-macros {: declare : define} :declare)

(test
  "var can be declared"
  (declare x)
  (set x 1)
  (lu.assertEquals x 1))

(test
  "var can be defined"
  (var x nil)
  (define x 3)
  (lu.assertEquals x 3))

(test
  "declared value can be defined"
  (declare x)
  (define x 2)
  (lu.assertEquals x 2)

  (declare f)
  (define f (fn [] 4))
  (lu.assertEquals (f) 4))

(test
  "defined value cannot be set again"
  (declare x)
  (define x 5))
  ;; (set x 6) ; will trigger Compile error

(test
  "cannot define undeclared/not-var variable"
  ;;(define x 6)) ; will trigger Compile error

  (local x 1))
  ;;(define x 2)) ; will trigger Compile error
