(import-macros {: with-splicing} :splicing)

(fn wrap-fn-return-nil [...]
  (with-splicing `(fn [] (&splice ,...) nil)))

{: wrap-fn-return-nil}
