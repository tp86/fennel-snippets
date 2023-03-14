(import-macros {: test} :tester)
(local lu (require :luaunit))

(import-macros {: with-splicing} :splicing)

(test
  "single form in splicing context is emitted"
  (lu.assertEquals (with-splicing 1) 1))

(test
  "multiple forms in splicing context are not supported"
  (let [(a b) (with-splicing 1 2)]
    (lu.assertEquals a 1)
    (lu.assertNil b)))

(test
  "splicing context with multi-values"
  (let [(a b) (with-splicing (values 1 2))]
    (lu.assertEquals a 1)
    (lu.assertEquals b 2))
  (let [(a b c) (with-splicing (values 1 2) 3)]
    (lu.assertEquals a 1)
    (lu.assertEquals b 2)
    (lu.assertNil c)))

(comment
  (test
    "splicing without form behaves as values"
    (let [(a b) (with-splicing (&splice 1 2))]
      (lu.assertEquals a 1)
      (lu.assertEquals b 2))))

(test
  "splicing in middle of list"
  (let [(a b c d) (with-splicing (values 1 (&splice 2 3) 4))]
    (lu.assertEquals a 1)
    (lu.assertEquals b 2)
    (lu.assertEquals c 3)
    (lu.assertEquals d 4)))

(test
  "splicing macros"
  (macro add [a]
    `(set ,a (+ ,a 1)))
  (macro mul [a]
    `(set ,a (* ,a 2)))
  (var a 1)
  (with-splicing
    (do
      (&splice (add a) (mul a))
      (set a (+ a 2))))
  (lu.assertEquals a 6))

(test
  "splicing context with sequence"
  (let [sequence (with-splicing [1 2 3])]
    (lu.assertEquals sequence [1 2 3])))

(test
  "splicing context with nested sequence"
  (let [sequence (with-splicing [1 [2] 3])]
    (lu.assertEquals sequence [1 [2] 3])))

(test
  "splicing at the end of enclosed sequence"
  (let [sequence (with-splicing [1 (&splice 2 3)])]
    (lu.assertEquals sequence [1 2 3])))

(test
  "splicing in the middle of enclosed sequence"
  (let [sequence (with-splicing [1 (&splice 2 3) 4])]
    (lu.assertEquals sequence [1 2 3 4])))

(test
  "splicing in nested sequence"
  (let [sequence (with-splicing [1 [2 (&splice 3 4) 5] 6])]
    (lu.assertEquals sequence [1 [2 3 4 5] 6])))

(test
  "splicing in complex code structure"
  (let [tbl (with-splicing {:a [1 (&splice 2 3) 4] :b ((fn [] [4 (&splice 3 2) 1]))})]
    (lu.assertEquals tbl.a [1 2 3 4])
    (lu.assertEquals tbl.b [4 3 2 1])))

(comment
  (test
    "splicing in macro"
    (import-macros {: wrap-fn-return-nil} :test-data.splicing-in-macro)
    (var x 1)
    (lu.assertNil ((wrap-fn-return-nil 1 (set x 2) 3)))
    (lu.assertEquals x 2)))
