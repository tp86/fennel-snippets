(fn declare [symbol]
  `(var ,symbol nil))

(fn var? [symbol]
  (?. (get-scope) :symmeta (tostring symbol) :var))

(fn define [symbol value]
  (assert-compile (var? symbol) "expected var in scope" symbol)
  ;; have to use `lua` here
  ;; macros can generally only return one form, so `(set ,symbol ,value) and then `(local ,symbol ,symbol) won't work
  ;; using `set` inside `local` with the same `symbol` generates compile error
  (let [symbol-mangled (in-scope? symbol)
        value-symbol (gensym)]
    `(local ,symbol
       (do
         (let [,value-symbol ,value]
           (lua ,(.. symbol-mangled " = " (tostring value-symbol)) ,symbol-mangled))))))

{: declare
 : define}
