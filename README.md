# Capítulo 1 — Flex & Bison (O’Reilly) · Trabajo práctico

---

## 📂 Estructura
```
.
├─ Ejemplos/
│  ├─ ex1-1_wordcount.l
│  ├─ ex1-2_plainflex.l
│  ├─ ex1-3_tokens.l
│  ├─ ex1-4_hand_scanner.c
│  ├─ ex1-5_calc.y
│  └─ ex1-5_scan.l
├─ Extras/
│  ├─ hexcalc_scan.l
│  ├─ bitcalc_scan.l
│  ├─ bitcalc_parser.y
│  └─ wordcount_c.c
└─ README.md
```

---

## Cómo compilar
Requisitos: `flex`, `bison`, `gcc` (o `clang`).

```bash
# Ejemplos 1-1 a 1-3 (solo flex)
make ex1-1 ex1-2 ex1-3

# Ejemplo 1-4 (scanner a mano en C)
make ex1-4

# Ejemplo 1-5 (calculadora flex+bison)
make calc

# Variante hexadecimal
make hexcalc

# Variante con operadores bit a bit
make bitcalc

# Word count en C
make wcc
```

---

## Cómo probar
```bash
# ex1-1 (wordcount básico)
echo "hola mundo
hola" | ./build/ex1-1

# ex1-2 (plain flex: imprime tokens crudos)
echo "a aa aaa" | ./build/ex1-2

# ex1-3 (tokens de números y signos)
echo "12 + |34|
" | ./build/ex1-3

# ex1-4 (scanner a mano)
echo "a / 34 + |45" | ./build/ex1-4

# calc (bison): líneas con expresiones; Enter evalúa
echo "2+3*4" | ./build/calc
echo "(2+3)*4 // comentario" | ./build/calc

# hexcalc
echo "0x2f + 10" | ./build/hexcalc

# bitcalc
echo "5 | 2 & 1" | ./build/bitcalc

# wordcount en C
./build/wcc archivo_grande.txt
```

---

# Análisis de los ejemplos

### Ejemplo 1-1 — Word count (flex)
- **Qué hace:** cuenta líneas, palabras y caracteres con reglas para saltos de línea, espacios y “otros caracteres”.
- **Prueba:** `echo -e "hola mundo
hola" | ./build/ex1-1` → salida tipo `1 2 11`.
- **Lección:** cómo acumular estadísticas dentro de acciones del escáner.

### Ejemplo 1-2 — Programas plain flex
- **Qué hace:** especificación mínima que emite el texto coincidente (`ECHO`) para ver tokenización.
- **Prueba:** `echo "a aa aaa" | ./build/ex1-2`.
- **Lección:** reglas vacías para ignorar espacios y `noyywrap` para evitar funciones extra.

### Ejemplo 1-3 — Escáner de tokens aritméticos
- **Qué hace:** reconoce números, signos `+ - * /`, paréntesis, `|` (valor absoluto), y comentarios `//`.
- **Prueba:** imprime tokens como `NUMBER(12)`, `PLUS`, `ABS`, `EOL`.
- **Lección:** cómo mapear símbolos a tokens para el parser.

### Ejemplo 1-4 — Escáner a mano en C
- **Qué hace:** tokeniza con `getchar`, `isdigit`, `ungetc`.
- **Prueba:** `echo "a / 34 + |45" | ./build/ex1-4` → salida de tokens.
- **Lección:** es más tedioso y propenso a errores que flex, aunque produce tokens equivalentes.

### Ejemplo 1-5 — Calculadora (flex + bison)
- **Qué hace:** gramática de expresiones aritméticas con `+ - * /`, valor absoluto `|x|`, paréntesis, comentarios `//`.
- **Prueba:** `echo "2+3*4" | ./build/calc` → `14`.
- **Lección:** combinación de escáner y parser, reglas para subexpresiones y comentarios.

---

# Ejercicios y respuestas

### 1) Manejo de comentarios
- **Pregunta:** ¿La calculadora aceptará una línea que contenga solo un comentario?  
- **Respuesta:** Sí, porque el escáner ignora el comentario y luego emite el `EOL`. El parser lo interpreta como una línea vacía. Si la regla de comentario consumiera también el `
`, habría que devolver un `EOL` explícitamente. Lo más sencillo es resolverlo en el escáner.

### 2) Conversión hexadecimal
- **Cambios:** en `extras/hexcalc_scan.l` se agregó un patrón `0[xX][0-9a-fA-F]+` y conversión con `strtol(...,16)`.  
- **Prueba:** `echo "0x2f + 10" | ./build/hexcalc` → `57`.  
- **Respuesta:** ahora la calculadora acepta decimales y hexadecimales.

### 3) Operadores de nivel de bits (AND, OR)
- **Problema:** `|` se usa tanto en valor absoluto como en OR.  
- **Solución:** en `bitcalc_parser.y` se diferenció con reglas:  
  - `ABS exp ABS` para valor absoluto.  
  - `exp '|' exp` para OR.  
  - Se añadió también `&` (AND).  
- **Prueba:** `echo "5 | 2 & 1" | ./build/bitcalc`.  
- **Respuesta:** se manejó con precedencias y reglas separadas en el parser.

### 4) Reconocimiento de tokens (escáner a mano vs flex)
- **Respuesta:** No son idénticos por defecto. El escáner a mano requiere código explícito para espacios, números y comentarios, mientras que en flex basta con reglas declarativas. Con cuidado pueden producir la misma salida, pero flex es más fácil de extender.

### 5) Limitaciones de Flex
- **Respuesta:** Flex es ideal para lenguajes regulares. No es adecuado para lenguajes con dependencias de contexto o estructuras anidadas complejas (XML bien anidado, indentación tipo Python, gramáticas sensibles al contexto). Estos casos requieren un parser.

### 6) Programa de conteo de palabras en C
- **Implementado en:** `extras/wordcount_c.c`.  
- **Prueba:** `./build/wcc archivo.txt`.  
- **Respuesta:** La versión en C puede ser un poco más rápida porque evita flex, pero es mucho más difícil de depurar y extender. Flex es más mantenible.

---

# Conclusión
Este trabajo muestra cómo Flex facilita la creación de escáneres eficientes y mantenibles, cómo integrarlos con Bison para parsers expresivos, y cómo resolver extensiones prácticas como hexadecimales y operadores bit a bit. Además, se comprobó la diferencia entre un escáner manual y uno generado por flex, y se evaluó el costo/beneficio de usar C puro.
