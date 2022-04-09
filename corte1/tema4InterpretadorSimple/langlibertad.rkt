#lang eopl
#|
Para la especificación léxica

    Los comentarios inician con punto y coma ";" y son de una linea
    Se tienen números positivos y negativos enteros y en punto flotante
    Todo texto inicia con comillas y termina en comillas
    Los identificadores inician con una letra seguido de cualquier numero de carácteres alfanumericos y simbolos especiales como ? ¿ #
<programa> ::= <expresion>
                (a-program (exp))
<expresion> ::= <identificador>
                             exp-literal(id)
                         ::= <numero>
                             exp-numero(dato)
                         ::=<texto>
                             exp-texto(dato)
                         ::= <booleano>
                            exp-booleano(dato)
                         ::= <primitiva>   "(" <expresion>*(,) ")"
                            exp-primitiva(op,expresiones)

<booleano> ::= "falso" | "verdadero"
                            (false-bool) | (verdadero-bool)

<primitiva> ::= "+"
                           sum-prim
                       ::= "-"
                           resta-prim
                       ::= "*"
                           mult-prim
                       ::= "/"
                           div-prim
                       ::= "%"
                           modulo-prim                      
                       ::= "<="
                           mayor-igual-prim
                        ::= ">="
                            menor-igual-prim
                        ::= ">"
                            mayor-prim
                         ::= "<"
                            menor-prim
                         ::= "y"
                            y-prim
                         ::= "o"
                            o-prim
                         ::= "o-exclusiva"
                            oex-prim
                         ::= "==>"
                            implicacion-prim
                         ::= "no"
                            negacion-prim
|#
(define lexica
  '(
    (comentario (";" (arbno (not #\newline))) skip)
    (espacio-blanco (whitespace) skip)
    (numero (digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit) "." digit (arbno digit)) number)
    (texto ("\"" (or letter digit) (arbno (or letter whitespace digit "?" "¿")) "\"") string)
    (identificador (letter (arbno (or digit "?" letter "#" "¿"))) symbol)
    ))

(define gramatical
  '(
    (programa (expresion) un-programa)
    (expresion (identificador) exp-literal)
    (expresion (numero) exp-numero)
    (expresion (booleano) exp-booleano)
    (expresion (texto) exp-texto)
    (expresion (primitiva "(" (separated-list expresion ",") ")") exp-primitiva)
    (expresion (numero texto) exp-rara)
    (primitiva ("+") sum-prim)
    (primitiva ("-") minus-prim)
    (primitiva ("*") mult-prim)
    (primitiva ("/") div-prim)
    (primitiva ("%") mod-prim)
    (primitiva (">=") mayor-igual-prim)
    (primitiva ("<=") menor-igual-prim)
    (primitiva (">") mayor-prim)
    (primitiva ("<") menor-prim)
    (primitiva ("y") y-prim)
    (primitiva ("o") o-prim)
    (primitiva ("o-ex") oex-prim)
    (primitiva ("==>") implicacion-prim)
    (primitiva ("no") no-prim)
    (booleano ("verdadero") verdadero-bool)
    (booleano ("falso") falso-bool)))

;;Construir los datatypes

(sllgen:make-define-datatypes lexica gramatical)

(define mostrar-tipoDeDatos
  (lambda () (sllgen:list-define-datatypes lexica gramatical)))

(define escanear
    (sllgen:make-string-scanner lexica gramatical))

(define parser
  (sllgen:make-string-parser lexica gramatical))