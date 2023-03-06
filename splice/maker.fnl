#!/usr/bin/env -S fennel --correlate

(macro prepend-path [pattern path]
  `(set ,path (.. ,pattern ";" ,path)))

(local fennel (require :fennel))
(prepend-path "../declare-define/src/?-macros.fnl" fennel.macro-path)

(fn test [args]
  (prepend-path "tester/?.fnl" fennel.path)
  (let [{: run} (require :tester)]
    (run args)))

(local commands
  {: test})

(fn run [args]
  (let [[command & args] (or args arg)
        command-name (or command :test)
        command (. commands command-name)]
    (if command
      (command args)
      (print (.. "Unknown command: " command-name)))))

(run arg)
