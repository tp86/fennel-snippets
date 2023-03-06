#!/usr/bin/env -S fennel --correlate

(local default-command-name :test)

(macro prepend-path [pattern path]
  `(set ,path (.. ,pattern ";" ,path)))

(local fennel (require :fennel))

(fn test [args]
  (print "Running test with args:")
  (each [_ a (ipairs args)]
    (print a)))

(local commands
  {: test})

(fn run [args]
  (let [[command & args] (or args arg)
        command-name (or command default-command-name)
        command (. commands command-name)]
    (if command
      (command args)
      (print (.. "Unknown command: " command-name)))))

(run arg)

