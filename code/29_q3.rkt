#lang racket/base

;; (inorder-acc tree acc) -> list
;; Purpose: the values of tree in inorder (left, node, right),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, there is nothing to add: the answer is acc.
;;   - If tree is (v left right):
;;       1. put the inorder of right in front of acc   -> R
;;       2. cons v onto R                              -> (v . R)
;;       3. put the inorder of left in front of that   -> answer
;;   Building from the right end means no append is needed.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))