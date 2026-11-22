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

;; (preorder-acc tree acc) -> list
;; Purpose: the values of tree in preorder (node, left, right),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, the answer is acc.
;;   - If tree is (v left right):
;;       1. put the preorder of right in front of acc  -> R
;;       2. put the preorder of left in front of R     -> L
;;       3. cons v onto L                              -> answer
;;   Pieces are added in reverse order (R, L, v) because the
;;   list is built from the right end.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-acc (cadr tree)
                          (preorder-acc (caddr tree) acc)))))

;; (postorder-acc tree acc) -> list
;; Purpose: the values of tree in postorder (left, right, node),
;;          placed in front of the list acc.
;; Recursive reading:
;;   - If tree is empty, the answer is acc.
;;   - If tree is (v left right):
;;       1. cons v onto acc                            -> (v . acc)
;;       2. put the postorder of right in front of it  -> R
;;       3. put the postorder of left in front of R    -> answer
;;   Pieces are added in reverse order (v, R, L) because the
;;   list is built from the right end.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (cadr tree)
                     (postorder-acc (caddr tree)
                                    (cons (car tree) acc)))))

;; (height tree) -> number
;; Purpose: the height of tree.
;; Recursive reading:
;;   - The height of the empty tree () is 0.
;;   - The height of (v left right) is 1 (for this node) plus
;;     the larger of the heights of left and right.
;;   The larger height is picked with if and >, since max is not an
;;   allowed built-in. So a single node (v () ()) has height 1 + 0 = 1.
(define (height tree)
  (if (null? tree)
      0
      (let ((hl (height (cadr tree)))
            (hr (height (caddr tree))))
        (if (> hl hr)
            (+ 1 hl)
            (+ 1 hr)))))

;; (leaf-count tree) -> number
;; Purpose: the number of leaves in tree.
;; Recursive reading:
;;   - The empty tree () has no leaves: 0.
;;   - A node whose left and right are both () is a leaf: 1.
;;   - Any other node is not a leaf itself, so its leaf count is
;;     the leaves of left plus the leaves of right.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else (+ (leaf-count (cadr tree))
                 (leaf-count (caddr tree))))))

;; (print-inorder tree) -> prints one line
;; Purpose: print the inorder list of tree, then a newline.
;; Reading: the inorder list of the whole tree is inorder-acc with
;;          nothing after it, i.e. acc = '(). Display it, then newline.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))

;; (print-all-traversals tree) -> prints three lines
;; Purpose: print the inorder, preorder and postorder lists of tree,
;;          one per line, in that order.
;; Reading: each line is the matching -acc helper called with
;;          acc = '() (nothing comes after the whole tree),
;;          shown with display and ended with newline.
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))

;; (print-height-and-leaves tree) -> prints one line
;; Purpose: print the two-element list (height leaf-count), then a newline.
;; Reading: build the list from the two helpers with list,
;;          display it, then newline.
(define (print-height-and-leaves tree)
  (display (list (height tree) (leaf-count tree)))
  (newline))