(import-macros {: test} :tester)
(local lu (require :luaunit))

(test
  "before macros"
  (var f nil)
  (fn g [x]
    (when (< 0 x) (f (- x 1))))
  (set f
       (fn [x]
         (when (< 0 x) (g (- x 1)))))
  (g 2))
