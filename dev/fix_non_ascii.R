#' @title Replace Non-ASCII Characters with ASCII Equivalents
#' 
#' @description Finds all non-ASCII (American Standard Code for Information Interchange) characters in a character vector and replaces them with their ASCII equivalents. For example, vowels with umlauts over them are returned as the vowel without accent marks. The function will return a warning if it finds any non-ASCII characters for which it does not have a hard-coded fix. Please open a [GitHub Issue](https://github.com/njlyon0/supportR/issues) if you encounter this warning but know what the replacement character should be for that particular character.
#' 
#' @param x (character) vector in which to fix non-ASCII characters
#' 
#' @return (character) vector where all non-ASCII characters have been replaced by ASCII equivalents
#' 
#' @export
#' 
#' @examples
#' # Make a vector of several non-ASCII characters
#' (bad_vec <- c("’", "“", "×", "ﬁ", "ö", "ü"))
#' 
#' # Invoke function
#' (good_vec <- fix_non_ascii(x = bad_vec))
#' 
#' # Check to see if that worked
#' good_vec[stringr::str_detect(string = good_vec, pattern = "[^[:ascii:]]") == TRUE]
#' 
fix_non_ascii <- function(x = NULL){
  
  # Error out if x isn't supplied
  if(is.null(x) == TRUE)
    stop("'x' must be specified")
  
  # Error out if x isn't a character
  if(is.character(x) != TRUE)
    stop("'x' must be a character")
  
  # Make a new object so we can make all find/replace steps identical
  q <- x
  
  # Do actual fixing
  ## Hyphens & Spacing ----
  q <- gsub(pattern = "\u00AC|\u00AF", replacement = "-", x = q)
  q <- gsub(pattern = "\u00AD", replacement = " ", x = q)
  
  ## Apostrophes & Quotes ----
  q <- gsub(pattern = "\u00B4", replacement = "'", x = q)

  ## Greek Letters ----
  q <- gsub(pattern = "\u00B5", replacement = "u", x = q) # mu ('micro')
  
  ## Math ----
  q <- gsub(pattern = "\u00B1", replacement = "+/-", x = q)
  q <- gsub(pattern = "\u2260", replacement = "=/=", x = q)
  q <- gsub(pattern = "\u00D7", replacement = "x", x = q)
  q <- gsub(pattern = "\u00B9", replacement = "^1", x = q)
  q <- gsub(pattern = "\u00B2", replacement = "^2", x = q)
  q <- gsub(pattern = "\u00B3", replacement = "^3", x = q)
  q <- gsub(pattern = "\u00BC", replacement = "1/4", x = q)
  q <- gsub(pattern = "\u00BD", replacement = "1/2", x = q)
  q <- gsub(pattern = "\u00BE", replacement = "3/4", x = q)
  
  
  ## Currency ----
  q <- gsub(pattern = "\u00A1", replacement = "!", x = q)
  q <- gsub(pattern = "\u00BF", replacement = "?", x = q)
  q <- gsub(pattern = "\u00A2", replacement = "c", x = q)
  q <- gsub(pattern = "\u00A3", replacement = "L", x = q)
  q <- gsub(pattern = "\u00A5", replacement = "Y", x = q)
  q <- gsub(pattern = "\u20AC", replacement = "E", x = q)
  q <- gsub(pattern = "\u00A4", replacement = "ox", x = q)
  
  ## Misc. Other ----
  q <- gsub(pattern = "\u00A6", replacement = "|", x = q)
  q <- gsub(pattern = "\u00A7", replacement = "S", x = q)
  q <- gsub(pattern = "\u00A8", replacement = "..", x = q)
  q <- gsub(pattern = "\u00A9", replacement = "(C)", x = q)
  q <- gsub(pattern = "\u00AA", replacement = "^a", x = q)
  q <- gsub(pattern = "\u00BA", replacement = "^o", x = q)
  q <- gsub(pattern = "\u00AB", replacement = "<<", x = q) 
  q <- gsub(pattern = "\u00BB", replacement = ">>", x = q) 
  q <- gsub(pattern = "\u00AE", replacement = "(R)", x = q)
  q <- gsub(pattern = "\u00B0", replacement = "o", x = q)
  q <- gsub(pattern = "\u00B6", replacement = "P", x = q) # paragraph symbol
  q <- gsub(pattern = "\u00B7", replacement = ".", x = q)
  q <- gsub(pattern = "\u00B8", replacement = ",", x = q)
  
  
  
  # UNSORTED ----
  q <- gsub(pattern = "\u00C0|\u00C1|\u00C2|\u00C3|\u00C4|\u00C5", replacement = "A", x = q)
  q <- gsub(pattern = "\u00E0|\u00E1|\u00E2|\u00E3|\u00E4|\u00E5", replacement = "a", x = q)
  q <- gsub(pattern = "\u00C6", replacement = "AE", x = q)
  q <- gsub(pattern = "\u00E6", replacement = "ae", x = q)
  q <- gsub(pattern = "\u00C7", replacement = "C", x = q)
  q <- gsub(pattern = "\u00E7", replacement = "c", x = q)
  q <- gsub(pattern = "\u00C8|\u00C9|\u00CA|\u00CB", replacement = "E", x = q)
  q <- gsub(pattern = "\u00E8|\u00E9|\u00EA|\u00EB", replacement = "e", x = q)
  q <- gsub(pattern = "\u00CC|\u00CD|\u00CE|\u00CF", replacement = "I", x = q)
  q <- gsub(pattern = "\u00EC|\u00ED|\u00EE|\u00EF", replacement = "i", x = q)
  q <- gsub(pattern = "\u00D0", replacement = "D", x = q)
  q <- gsub(pattern = "\u00F0", replacement = "d", x = q)
  q <- gsub(pattern = "\u00D1", replacement = "N", x = q)
  q <- gsub(pattern = "\u00F1", replacement = "n", x = q)
  q <- gsub(pattern = "\u00D2|\u00D3|\u00D4|\u00D5|\u00D6", replacement = "O", x = q)
  q <- gsub(pattern = "\u00F2|\u00F3|\u00F4|\u00F5|\u00F6", replacement = "o", x = q)
  q <- gsub(pattern = "\u00D8", replacement = "0", x = q)
  q <- gsub(pattern = "\u00F8", replacement = "o", x = q)
  q <- gsub(pattern = "\u00D9|\u00DA|\u00DB|\u00DC", replacement = "U", x = q)
  q <- gsub(pattern = "\u00F9|\u00FA|\u00FB|\u00FC", replacement = "u", x = q)
  q <- gsub(pattern = "\u00DD", replacement = "Y", x = q)
  q <- gsub(pattern = "\u00FD|\u00FF", replacement = "y", x = q)
  q <- gsub(pattern = "\u00DE", replacement = "P", x = q)
  q <- gsub(pattern = "\u00FE", replacement = "p", x = q)
  q <- gsub(pattern = "\u00DF", replacement = "B", x = q)
  q <- gsub(pattern = "\u00F7", replacement = "/", x = q) # math
  q <- gsub(pattern = "\u0192", replacement = "f", x = q) # math
  
  # Greek
  q <- gsub(pattern = "\u0391", replacement = "ALPHA", x = q)
  q <- gsub(pattern = "\u03B1", replacement = "alpha", x = q)
  q <- gsub(pattern = "\u0392", replacement = "BETA", x = q)
  q <- gsub(pattern = "\u03B2", replacement = "beta", x = q)
  q <- gsub(pattern = "\u0393", replacement = "GAMMA", x = q)
  q <- gsub(pattern = "\u03B3", replacement = "gamma", x = q)
  q <- gsub(pattern = "\u0394", replacement = "DELTA", x = q)
  q <- gsub(pattern = "\u03B4", replacement = "delta", x = q)
  q <- gsub(pattern = "\u0395", replacement = "EPSILON", x = q)
  q <- gsub(pattern = "\u0395", replacement = "epsilon", x = q)
  q <- gsub(pattern = "\u0396", replacement = "ZETA", x = q)
  q <- gsub(pattern = "\u03B6", replacement = "zeta", x = q)
  q <- gsub(pattern = "\u0397", replacement = "ETA", x = q)
  q <- gsub(pattern = "\u03B7", replacement = "eta", x = q)
  q <- gsub(pattern = "\u0398", replacement = "THETA", x = q)
  q <- gsub(pattern = "\u03B8|\u03C9", replacement = "theta", x = q)
  q <- gsub(pattern = "\u0399", replacement = "IOTA", x = q)
  q <- gsub(pattern = "\u03B9", replacement = "iota", x = q)
  q <- gsub(pattern = "\u039A", replacement = "KAPPA", x = q)
  q <- gsub(pattern = "\u03BA", replacement = "kappa", x = q)
  q <- gsub(pattern = "\u039B", replacement = "LAMBDA", x = q)
  q <- gsub(pattern = "\u03BB", replacement = "lamda", x = q)
  q <- gsub(pattern = "\u039C", replacement = "MU", x = q)
  q <- gsub(pattern = "\u03BC", replacement = "mu", x = q)
  q <- gsub(pattern = "\u039D", replacement = "NU", x = q)
  q <- gsub(pattern = "\u03BD", replacement = "nu", x = q)
  q <- gsub(pattern = "\u039E", replacement = "XI", x = q)
  q <- gsub(pattern = "\u03BE", replacement = "xi", x = q)
  q <- gsub(pattern = "\u039F", replacement = "OMICRON", x = q)
  q <- gsub(pattern = "\u03BF", replacement = "omicron", x = q)
  q <- gsub(pattern = "\u03A0", replacement = "PI", x = q)
  q <- gsub(pattern = "\u03C0|\u03D6", replacement = "pi", x = q)
  q <- gsub(pattern = "\u03A1", replacement = "RHO", x = q)
  q <- gsub(pattern = "\u03C1", replacement = "rho", x = q)
  q <- gsub(pattern = "\u03A3", replacement = "SIGMA", x = q)
  q <- gsub(pattern = "\u03C3", replacement = "sigma", x = q)
  q <- gsub(pattern = "\u03A4", replacement = "TAU", x = q)
  q <- gsub(pattern = "\u03C4", replacement = "tau", x = q)
  q <- gsub(pattern = "\u03A5", replacement = "UPSILON", x = q)
  q <- gsub(pattern = "\u03C5|\u03D2", replacement = "upsilon", x = q)
  q <- gsub(pattern = "\u03A6", replacement = "PHI", x = q)
  q <- gsub(pattern = "\u03C6", replacement = "phi", x = q)
  q <- gsub(pattern = "\u03A7", replacement = "CHI", x = q)
  q <- gsub(pattern = "\u03C7", replacement = "chi", x = q)
  q <- gsub(pattern = "\u03A8", replacement = "PSI", x = q)
  q <- gsub(pattern = "\u03C8", replacement = "psi", x = q)
  q <- gsub(pattern = "\u03A9", replacement = "OMEGA", x = q)
  q <- gsub(pattern = "\u03C9", replacement = "omega", x = q)
  q <- gsub(pattern = "\u03C9", replacement = "omega", x = q)
  
  stringi::stri_escape_unicode("ϖ")

  bad_chars <- c(¡, ¢, £, ¤, ¥, ¦, §, ¨, ©, ª, «, ¬, ­, ®, ¯, °, ±, ², ³, ´, µ, ¶, ·, ¸, ¹, º, », ¼, ½, ¾, ¿, À, Á, Â, Ã, Å, Æ, Ç, È, É, Ê, Ì, Í, Î, Ï, Ð, Ñ, Ò, Ó, Ô, Õ, Ö, Ø, Ù, Ú, Û, Ü, Ý, Þ, ß, à, á, â, ã, ä, æ, ç, è, é, ê, ë, ì, í, î, ï, ð, ñ, ò, ó, ô, õ, ö, ÷, ø, ù, ú, û, ü, ý, þ, ÿ, ƒ, Α, Β, Γ, Δ, Ε, Ζ, Η, Θ, Ι, Κ, Λ, Μ, Ν, Ξ, Ο, Π, Ρ, Σ, Τ, Υ, Φ, Χ, Ψ, Ω, α, β, γ, δ,	ε, ζ, η, θ, ι, κ, λ, μ, ν, ξ, ο, π, ρ, ς, σ, τ, υ, φ, χ, ψ, ϑ, ϒ, ϖ
                  
)
  
   	
  
    
    
    
    bullet = black small circle 	&bull;	• 	&#8226;	•
    horizontal ellipsis = three dot leader 	&hellip;	… 	&#8230;	…
    prime = minutes = feet 	&prime;	′ 	&#8242;	′
    double prime = seconds = inches 	&Prime;	″ 	&#8243;	″
    overline = spacing overscore 	&oline;	‾ 	&#8254;	‾
    fraction slash 	&frasl;	⁄ 	&#8260;	⁄
    script capital P = power set 	&weierp;	℘ 	&#8472;	℘
    blackletter capital I = imaginary part 	&image;	ℑ 	&#8465;	ℑ
    blackletter capital R = real part symbol 	&real;	ℜ 	&#8476;	ℜ
    trade mark sign 	&trade;	™ 	&#8482;	™
    alef symbol = first transfinite cardinal 	&alefsym;	ℵ 	&#8501;	ℵ
    leftwards arrow 	&larr;	← 	&#8592;	←
    upwards arrow 	&uarr;	↑ 	&#8593;	↑
    rightwards arrow 	&rarr;	→ 	&#8594;	→
    downwards arrow 	&darr;	↓ 	&#8595;	↓
    left right arrow 	&harr;	↔ 	&#8596;	↔
    downwards arrow with corner leftwards 	&crarr;	↵ 	&#8629;	↵
    leftwards double arrow 	&lArr;	⇐ 	&#8656;	⇐
    upwards double arrow 	&uArr;	⇑ 	&#8657;	⇑
    rightwards double arrow 	&rArr;	⇒ 	&#8658;	⇒
    downwards double arrow 	&dArr;	⇓ 	&#8659;	⇓
    left right double arrow 	&hArr;	⇔ 	&#8660;	⇔
    for all 	&forall;	∀ 	&#8704;	∀
    partial differential 	&part;	∂ 	&#8706;	∂
    there exists 	&exist;	∃ 	&#8707;	∃
    empty set = null set = diameter 	&empty;	∅ 	&#8709;	∅
    nabla = backward difference 	&nabla;	∇ 	&#8711;	∇
    element of 	&isin;	∈ 	&#8712;	∈
    not an element of 	&notin;	∉ 	&#8713;	∉
    contains as member 	&ni;	∋ 	&#8715;	∋
    n-ary product = product sign 	&prod;	∏ 	&#8719;	∏
    n-ary sumation 	&sum;	∑ 	&#8721;	∑
    minus sign 	&minus;	− 	&#8722;	−
    asterisk operator 	&lowast;	∗ 	&#8727;	∗
    square root = radical sign 	&radic;	√ 	&#8730;	√
    proportional to 	&prop;	∝ 	&#8733;	∝
    infinity 	&infin;	∞ 	&#8734;	∞
    angle 	&ang;	∠ 	&#8736;	∠
    logical and = wedge 	&and;	∧ 	&#8743;	∧
    logical or = vee 	&or;	∨ 	&#8744;	∨
    intersection = cap 	&cap;	∩ 	&#8745;	∩
    union = cup 	&cup;	∪ 	&#8746;	∪
    integral 	&int;	∫ 	&#8747;	∫
    therefore 	&there4;	∴ 	&#8756;	∴
    tilde operator = varies with = similar to 	&sim;	∼ 	&#8764;	∼
    approximately equal to 	&cong;	≅ 	&#8773;	≅
    almost equal to = asymptotic to 	&asymp;	≈ 	&#8776;	≈
    not equal to 	&ne;	≠ 	&#8800;	≠
    identical to 	&equiv;	≡ 	&#8801;	≡
    less-than or equal to 	&le;	≤ 	&#8804;	≤
    greater-than or equal to 	&ge;	≥ 	&#8805;	≥
    subset of 	&sub;	⊂ 	&#8834;	⊂
    superset of 	&sup;	⊃ 	&#8835;	⊃
    not a subset of 	&nsub;	⊄ 	&#8836;	⊄
    subset of or equal to 	&sube;	⊆ 	&#8838;	⊆
    superset of or equal to 	&supe;	⊇ 	&#8839;	⊇
    circled plus = direct sum 	&oplus;	⊕ 	&#8853;	⊕
    circled times = vector product 	&otimes;	⊗ 	&#8855;	⊗
    up tack = orthogonal to = perpendicular 	&perp;	⊥ 	&#8869;	⊥
    dot operator 	&sdot;	⋅ 	&#8901;	⋅
    left ceiling = apl upstile 	&lceil;	⌈ 	&#8968;	⌈
    right ceiling 	&rceil;	⌉ 	&#8969;	⌉
    left floor = apl downstile 	&lfloor;	⌊ 	&#8970;	⌊
    right floor 	&rfloor;	⌋ 	&#8971;	⌋
    left-pointing angle bracket = bra 	&lang;	⟨ 	&#9001;	〈
    right-pointing angle bracket = ket 	&rang;	⟩ 	&#9002;	〉
    lozenge 	&loz;	◊ 	&#9674;	◊
    black spade suit 	&spades;	♠ 	&#9824;	♠
    black club suit = shamrock 	&clubs;	♣ 	&#9827;	♣
    black heart suit = valentine 	&hearts;	♥ 	&#9829;	♥
    black diamond suit 	&diams;	♦ 	&#9830;	♦
    quotation mark = APL quote 	&quot;	" 	&#34;	"
  ampersand 	&amp;	& 	&#38;	&
    less-than sign 	&lt;	< 	&#60;	<
    greater-than sign 	&gt;	> 	&#62;	>
    latin capital ligature OE 	&OElig;	Œ 	&#338;	Œ
    latin small ligature oe 	&oelig;	œ 	&#339;	œ
    latin capital letter S with caron 	&Scaron;	Š 	&#352;	Š
    latin small letter s with caron 	&scaron;	š 	&#353;	š
    latin capital letter Y with diaeresis 	&Yuml;	Ÿ 	&#376;	Ÿ
    modifier letter circumflex accent 	&circ;	ˆ 	&#710;	ˆ
    small tilde 	&tilde;	˜ 	&#732;	˜
    en space 	&ensp;	  	&#8194;	 
    em space 	&emsp;	  	&#8195;	 
    thin space 	&thinsp;	  	&#8201;	 
    zero width non-joiner 	&zwnj;	‌ 	&#8204;	‌
    zero width joiner 	&zwj;	‍ 	&#8205;	‍
    left-to-right mark 	&lrm;	‎ 	&#8206;	‎
    right-to-left mark 	&rlm;	‏ 	&#8207;	‏
    en dash 	&ndash;	– 	&#8211;	–
    em dash 	&mdash;	— 	&#8212;	—
    left single quotation mark 	&lsquo;	‘ 	&#8216;	‘
    right single quotation mark 	&rsquo;	’ 	&#8217;	’
    single low-9 quotation mark 	&sbquo;	‚ 	&#8218;	‚
    left double quotation mark 	&ldquo;	“ 	&#8220;	“
    right double quotation mark 	&rdquo;	” 	&#8221;	”
    double low-9 quotation mark 	&bdquo;	„ 	&#8222;	„
    dagger 	&dagger;	† 	&#8224;	†
    double dagger 	&Dagger;	‡ 	&#8225;	‡
    per mille sign 	&permil;	‰ 	&#8240;	‰
    single left-pointing angle quotation mark 	&lsaquo;	‹ 	&#8249;	‹
    single right-pointing angle quotation mark 	&rsaquo;	› 	&#8250;	›

  
  # ## Quotes / apostrophes
  # q <- gsub(pattern = "’|`", replacement = "'", x = q)
  # q <- gsub(pattern = "“|”", replacement = '"', x = q)
  # ## Dashes / symbols
  # q <- gsub(pattern = "—|−|–", replacement = "-", x = q)
  # q <- gsub(pattern = "×", replacement = "*", x = q)
  # q <- gsub(pattern = "·", replacement = ".", x = q)
  # q <- gsub(pattern = "…", replacement = "...", x = q)
  # ## Spaces
  # q <- gsub(pattern = "­", replacement = " ", x = q)
  # ## Letters
  # q <- gsub(pattern = "ﬁ", replacement = "fi", x = q)
  # q <- gsub(pattern = "ö|ó|ò", replacement = "o", x = q)
  # q <- gsub(pattern = "ë|é|è", replacement = "e", x = q)
  # q <- gsub(pattern = "ä|á|à|å", replacement = "a", x = q)
  # q <- gsub(pattern = "ü|ú|ù", replacement = "u", x = q)
  
  # See if any are not fixed manually above
  unfixed <- q[stringr::str_detect(string = q, pattern = "[^[:ascii:]]") == TRUE]
  
  # Give a warning if any are found
  if(length(unfixed) != 0){
    warning("Failed to fix following non-ASCII characters: ", 
            paste0("'", unfixed, "'", collapse = "', '"), 
            "\nPlease open a GitHub Issue if you'd like this function to support a particular fix for this character") }
  
  # Return that fixed vector
  return(q) }




stringi::stri_escape_unicode("£")

sprintf("%X", as.integer(charToRaw("£")))



gsub(pattern = "\u00a3", replacement = "xx", x = "£")
stringr::str_detect(string = "\u00A3", pattern = "[[:ascii:]]")



