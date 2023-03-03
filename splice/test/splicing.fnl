(import-macros {: test} :tester)
(local lu (require :luaunit))

(import-macros {: !^} :splicing)

(test
  "single form in splicing context is emitted"
  (lu.assertEquals (!^ 1) 1))

(test
  "multiple forms in splicing context are not supported"
  (let [(a b) (!^ 1 2)]
    (lu.assertEquals a 1)
    (lu.assertNil b)))

(test
  "splicing context with multi-values"
  (let [(a b) (!^ (values 1 2))]
    (lu.assertEquals a 1)
    (lu.assertEquals b 2))
  (let [(a b c) (!^ (values 1 2) 3)]
    (lu.assertEquals a 1)
    (lu.assertEquals b 2)
    (lu.assertNil c)))

(test
  "splicing context with sequence"
  (let [sequence (!^ [1 2 3])]
    (lu.assertEquals sequence [1 2 3])))

(test
  "splicing context with nested sequence"
  (let [sequence (!^ [1 [2] 3])]
    (lu.assertEquals sequence [1 [2] 3])))

(test
  "splicing at the end of enclosed sequence"
  (let [sequence (!^ [1 (&^ 2 3)])]
    (lu.assertEquals sequence [1 2 3])))

(test
  "splicing in the middle of enclosed sequence"
  (let [sequence (!^ [1 (&^ 2 3) 4])]
    (lu.assertEquals sequence [1 2 3 4])))

(test
  "splicing in nested sequence"
  (let [sequence (!^ [1 [2 (&^ 3 4) 5] 6])]
    (lu.assertEquals sequence [1 [2 3 4 5] 6])))
