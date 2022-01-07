#!/usr/bin/env racket
#lang racket

(require "dag-to-graph.rkt")
(require "string-to-list.rkt")

;; command line parser
(define dag
  (command-line

   #:args (dagstr)

   dagstr))

;; prints the graph
(display (get-graph (string-to-list dag) "simple_graph"))
(printf "\n")
