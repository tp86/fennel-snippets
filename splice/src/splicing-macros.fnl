(local splicing-symbol (sym "&splice"))

(fn with-splicing [form]
  (when (or
          (list? form)
          (table? form))
    (each [subform-idx subform (pairs form)]
      (if (and
            (list? subform)
            (= splicing-symbol (. subform 1)))
        (do
          (table.remove form subform-idx)
          (each [spliced-subform-idx spliced-subform (ipairs subform)]
            (when (< 1 spliced-subform-idx)
              (table.insert form
                            (+ subform-idx (- spliced-subform-idx 2))
                            (with-splicing spliced-subform)))))
        (with-splicing subform))))
  form)

{: with-splicing}
