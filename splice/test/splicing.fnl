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
    (lu.assertEquals b 2)))
