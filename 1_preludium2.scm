;; BWV 847 using impromptu (http://impromptu.moso.com.au/)
;; (c) nekotwi, 2010

(au:clear-graph)
(define piano (au:make-node "aumu" "dls " "appl"))
(au:connect-node piano 0 *au:output-node* 0)
(au:update-graph)
(define bpm 100)
(define (beat)
   (/ *minute* bpm))
(define (note1) (* (beat) 4))
(define (note2)
   (* (beat) 2))
(define (note4)
   (beat))
(define (note8)
   (/ (beat) 2))
(define (note16)
   (/ (beat) 4))

(define (n note oct)
  (+ 60 (* 12 oct) (cond ((string-ci=? note "C") 0)
                         ((string-ci=? note "C#") 1)
                         ((string-ci=? note "Db") 1)
                         ((string-ci=? note "D") 2)
                         ((string-ci=? note "D#") 3)
                         ((string-ci=? note "Eb") 3)
                         ((string-ci=? note "E") 4)
                         ((string-ci=? note "F") 5)
                         ((string-ci=? note "F#") 6)
                         ((string-ci=? note "Gb") 6)
                         ((string-ci=? note "G") 7)
                         ((string-ci=? note "G#") 8)
                         ((string-ci=? note "Ab") 8)
                         ((string-ci=? note "A") 9)
                         ((string-ci=? note "A#") 10)
                         ((string-ci=? note "Hb") 10)
                         ((string-ci=? note "H") 11)
                         ((string-ci=? note "Bb") 10)
                         ((string-ci=? note "B") 11)
                         )))

(define (arp n1 n2 n3 n4)
   (list (list 'note n1 (note16) 100)
         (list 'note n2 (note16) 80)
         (list 'note n3 (note16) 80)
         (list 'note n2 (note16) 80)
         (list 'note n4 (note16) 80)
         (list 'note n2 (note16) 80)
         (list 'note n3 (note16) 80)
         (list 'note n2 (note16) 80)

         (list 'note n1 (note16) 100)
         (list 'note n2 (note16) 80)
         (list 'note n3 (note16) 80)
         (list 'note n2 (note16) 80)
         (list 'note n4 (note16) 80)
         (list 'note n2 (note16) 80)
         (list 'note n3 (note16) 80)
         (list 'note n2 (note16) 80)
   ))

(define (evalnote note time instrument)
   (play-note time instrument (cadr note) (cadddr note) (caddr note)))
(define (evalchord chord time instrument)
   (map (lambda (note)
           (evalnote note time instrument))
        (caddr chord)
        ))

(define (gettime elem)
   (cond ((equal? (car elem) 'note)
          (caddr elem))
         ((equal? (car elem) 'chord)
          (cadr elem))
         ((equal? (car elem) 'pause)
          (cadr elem))))
(define (empty? l)
   (equal? l '()))

(define (playlist elems time instrument)
   (if (not (empty? elems))
       (begin (define elem (car elems))
              (cond ((equal? (car elem) 'note)
                     (evalnote elem time instrument))
                    ((equal? (car elem) 'chord)
                     (evalchord elem time instrument)))
              (playlist (cdr elems) (+ time (gettime elem)) instrument))))
(begin (define time (+ (now) (/ *second* 2)))
(playlist (append (arp (n "c" 1) (n "eb" 0) (n "d" 0) (n "c" 0))
                  (arp (n "ab" 0) (n "f" 0) (n "e" 0) (n "c" 0))
                  (arp (n "h" 0) (n "f" 0) (n "eb" 0) (n "d" 0))
                  (arp (n "c" 1) (n "g" 0) (n "f" 0) (n "eb" 0))
                  (arp (n "eb" 1) (n "ab" 0) (n "g" 0) (n "eb" 0)) ;; 5
                  (arp (n "d" 1) (n "f#" 0) (n "e" 0) (n "d" 0))
                  (arp (n "d" 1) (n "g" 0) (n "f#" 0) (n "d" 0))
                  (arp (n "c" 1) (n "e" 0) (n "d" 0) (n "c" 0))
                  (arp (n "c" 1) (n "f" 0) (n "e" 0) (n "c" 0))
                  (arp (n "hb" 0) (n "f" 0) (n "eb" 0) (n "d" 0)) ;; 10
                  (arp (n "hb" 0) (n "g" 0) (n "f" 0) (n "eb" 0))
                  (arp (n "ab" 0) (n "g" 0) (n "f" 0) (n "eb" 0))
                  (arp (n "ab" 0) (n "d" 0) (n "c" 0) (n "hb" -1))
                  (arp (n "g" 0) (n "hb" -1) (n "ab" -1) (n "eb" 0))
                  (arp (n "f" 0) (n "c" 0) (n "hb" -1) (n "a" -1)) ;; 15
                  (arp (n "f" 0) (n "d" 0) (n "c" 0) (n "h" -1))
                  (arp (n "f" 0) (n "d" 0) (n "c" 0) (n "h" -1))
                  (arp (n "eb" 0) (n "c" 0) (n "h" -1) (n "g" -1))
                  )
          time
          piano)
(playlist (append (arp (n "c" -1) (n "g" -1) (n "f" -1) (n "eb" -1))
                  (arp (n "c" -1) (n "ab" -1) (n "g" -1) (n "f" -1))
                  (arp (n "c" -1) (n "ab" -1) (n "g" -1) (n "f" -1))
                  (arp (n "c" -1) (n "eb" -1) (n "d" -1) (n "g" -1))
                  (arp (n "c" -1) (n "c" 0) (n "hb" -1) (n "ab" -1)) ;; 5
                  (arp (n "c" -1) (n "a" -1) (n "g" -1) (n "f#" -1))
                  (arp (n "hb" -2) (n "hb" -1) (n "a" -1) (n "g" -1))
                  (arp (n "hb" -2) (n "g" -1) (n "f" -1) (n "e" -1))
                  (arp (n "ab" -2) (n "ab" -1) (n "g" -1) (n "f" -1))
                  (arp (n "ab" -2) (n "d" -1) (n "c" -1) (n "f" -1)) ;; 10
                  (arp (n "g" -2) (n "eb" -1) (n "d" -1) (n "g" -1))
                  (arp (n "c" -1) (n "eb" -1) (n "d" -1) (n "ab" -1))
                  (arp (n "d" -1) (n "f" -1) (n "eb" -1) (n "ab" -1))
                  (arp (n "eb" -1) (n "g" -1) (n "f" -1) (n "ab" -1))
                  (arp (n "eb" -1) (n "a" -1) (n "g" -1) (n "f" -1)) ;; 15
                  (arp (n "d" -1) (n "f" -1) (n "eb" -1) (n "ab" -1))
                  (arp (n "c" -1) (n "f" -1) (n "e" -1) (n "ab" -1))
                  (arp (n "c" -1) (n "eb" -1) (n "d" -1) (n "f" -1))
                  )
          time
          piano))