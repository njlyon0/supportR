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
  
  
  stringi::stri_escape_unicode("¿")
  
  q <- gsub(pattern = "\u00FC", replacement = "u", x = q)
  
  ## Greek Letters ----
  q <- gsub(pattern = "\u00B5", replacement = "u", x = q) # mu ('micro')
  
  ## Misc. Math ----
  q <- gsub(pattern = "\u00B1", replacement = "+/-", x = q)
  q <- gsub(pattern = "\u2260", replacement = "=/=", x = q)
  q <- gsub(pattern = "\u00D7", replacement = "x", x = q)
  q <- gsub(pattern = "\u00B9", replacement = "^1", x = q)
  q <- gsub(pattern = "\u00B2", replacement = "^2", x = q)
  q <- gsub(pattern = "\u00B3", replacement = "^3", x = q)
  q <- gsub(pattern = "\u00BC", replacement = "1/4", x = q)
  q <- gsub(pattern = "\u00BD", replacement = "1/2", x = q)
  q <- gsub(pattern = "\u00BE", replacement = "3/4", x = q)
  
  
  ## Misc. Symbols ----
  q <- gsub(pattern = "\u00A1", replacement = "!", x = q)
  q <- gsub(pattern = "\u00BF", replacement = "?", x = q)
  q <- gsub(pattern = "\u00A2", replacement = "c", x = q)
  q <- gsub(pattern = "\u00A3", replacement = "L", x = q)
  q <- gsub(pattern = "\u00A5", replacement = "Y", x = q)
  q <- gsub(pattern = "\u20AC", replacement = "E", x = q)
  q <- gsub(pattern = "\u00A4", replacement = "ox", x = q)
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
  
  
  stringi::stri_escape_unicode("¼")

  q <- gsub(pattern = "\u00", replacement = "", x = q)
  
  
  # Letters ----
  q <- gsub(pattern = "\u00FC", replacement = "u", x = q)
  
  
  stringi::stri_escape_unicode("×")
  
  q <- gsub(pattern = "\u00", replacement = "", x = q)
  
  À 	&#192;	À
    latin capital letter A with acute 	&Aacute;	Á 	&#193;	Á
    latin capital letter A with circumflex 	&Acirc;	Â 	&#194;	Â
    latin capital letter A with tilde 	&Atilde;	Ã 	&#195;	Ã
    latin capital letter A with diaeresis 	&Auml;	Ä 	&#196;	Ä
    latin capital letter A with ring above 	&Aring;	Å 	&#197;	Å
    latin capital letter AE 	&AElig;	Æ
  Ç 	&#199;	Ç
    latin capital letter E with grave 	&Egrave;	È 	&#200;	È
    latin capital letter E with acute 	&Eacute;	É 	&#201;	É
    latin capital letter E with circumflex 	&Ecirc;	Ê 	&#202;	Ê
    latin capital letter E with diaeresis 	&Euml;	Ë 	&#203;	Ë
    latin capital letter I with grave 	&Igrave;	Ì 	&#204;	Ì
    latin capital letter I with acute 	&Iacute;	Í 	&#205;	Í
    latin capital letter I with circumflex 	&Icirc;	Î 	&#206;	Î
    latin capital letter I with diaeresis 	&Iuml;	Ï 	&#207;	Ï
    latin capital letter ETH 	&ETH;	Ð 	&#208;	Ð
    latin capital letter N with tilde 	&Ntilde;	Ñ 	&#209;	Ñ
    latin capital letter O with grave 	&Ograve;	Ò 	&#210;	Ò
    latin capital letter O with acute 	&Oacute;	Ó 	&#211;	Ó
    latin capital letter O with circumflex 	&Ocirc;	Ô 	&#212;	Ô
    latin capital letter O with tilde 	&Otilde;	Õ 	&#213;	Õ
    latin capital letter O with diaeresis 	&Ouml;	Ö 	&#214;	Ö
    multiplication sign 	&times;	× 	&#215;	×
    latin capital letter O with stroke 	&Oslash;	Ø 	&#216;	Ø
    latin capital letter U with grave 	&Ugrave;	Ù 	&#217;	Ù
    latin capital letter U with acute 	&Uacute;	Ú 	&#218;	Ú
    latin capital letter U with circumflex 	&Ucirc;	Û 	&#219;	Û
    latin capital letter U with diaeresis 	&Uuml;	Ü 	&#220;	Ü
    latin capital letter Y with acute 	&Yacute;	Ý 	&#221;	Ý
    latin capital letter THORN 	&THORN;	Þ 	&#222;	Þ
    latin small letter sharp s = ess-zed 	&szlig;	ß 	&#223;	ß
    latin small letter a with grave 	&agrave;	à 	&#224;	à
    latin small letter a with acute 	&aacute;	á 	&#225;	á
    latin small letter a with circumflex 	&acirc;	â 	&#226;	â
    latin small letter a with tilde 	&atilde;	ã 	&#227;	ã
    latin small letter a with diaeresis 	&auml;	ä 	&#228;	ä
    latin small letter a with ring above 	&aring;	å 	&#229;	å
    latin small letter ae 	&aelig;	æ 	&#230;	æ
    latin small letter c with cedilla 	&ccedil;	ç 	&#231;	ç
    latin small letter e with grave 	&egrave;	è 	&#232;	è
    latin small letter e with acute 	&eacute;	é 	&#233;	é
    latin small letter e with circumflex 	&ecirc;	ê 	&#234;	ê
    latin small letter e with diaeresis 	&euml;	ë 	&#235;	ë
    latin small letter i with grave 	&igrave;	ì 	&#236;	ì
    latin small letter i with acute 	&iacute;	í 	&#237;	í
    latin small letter i with circumflex 	&icirc;	î 	&#238;	î
    latin small letter i with diaeresis 	&iuml;	ï 	&#239;	ï
    latin small letter eth 	&eth;	ð 	&#240;	ð
    latin small letter n with tilde 	&ntilde;	ñ 	&#241;	ñ
    latin small letter o with grave 	&ograve;	ò 	&#242;	ò
    latin small letter o with acute 	&oacute;	ó 	&#243;	ó
    latin small letter o with circumflex 	&ocirc;	ô 	&#244;	ô
    latin small letter o with tilde 	&otilde;	õ 	&#245;	õ
    latin small letter o with diaeresis 	&ouml;	ö 	&#246;	ö
    division sign 	&divide;	÷ 	&#247;	÷
    latin small letter o with stroke 	&oslash;	ø 	&#248;	ø
    latin small letter u with grave 	&ugrave;	ù 	&#249;	ù
    latin small letter u with acute 	&uacute;	ú 	&#250;	ú
    latin small letter u with circumflex 	&ucirc;	û 	&#251;	û
    latin small letter u with diaeresis 	&uuml;	ü 	&#252;	ü
    latin small letter y with acute 	&yacute;	ý 	&#253;	ý
    latin small letter thorn with 	&thorn;	þ 	&#254;	þ
    latin small letter y with diaeresis 	&yuml;	ÿ 	&#255;	ÿ
    latin small f with hook = function 	&fnof;	ƒ 	&#402;	ƒ
    greek capital letter alpha 	&Alpha;	Α 	&#913;	Α
    greek capital letter beta 	&Beta;	Β 	&#914;	Β
    greek capital letter gamma 	&Gamma;	Γ 	&#915;	Γ
    greek capital letter delta 	&Delta;	Δ 	&#916;	Δ
    greek capital letter epsilon 	&Epsilon;	Ε 	&#917;	Ε
    greek capital letter zeta 	&Zeta;	Ζ 	&#918;	Ζ
    greek capital letter eta 	&Eta;	Η 	&#919;	Η
    greek capital letter theta 	&Theta;	Θ 	&#920;	Θ
    greek capital letter iota 	&Iota;	Ι 	&#921;	Ι
    greek capital letter kappa 	&Kappa;	Κ 	&#922;	Κ
    greek capital letter lambda 	&Lambda;	Λ 	&#923;	Λ
    greek capital letter mu 	&Mu;	Μ 	&#924;	Μ
    greek capital letter nu 	&Nu;	Ν 	&#925;	Ν
    greek capital letter xi 	&Xi;	Ξ 	&#926;	Ξ
    greek capital letter omicron 	&Omicron;	Ο 	&#927;	Ο
    greek capital letter pi 	&Pi;	Π 	&#928;	Π
    greek capital letter rho 	&Rho;	Ρ 	&#929;	Ρ
    greek capital letter sigma 	&Sigma;	Σ 	&#931;	Σ
    greek capital letter tau 	&Tau;	Τ 	&#932;	Τ
    greek capital letter upsilon 	&Upsilon;	Υ 	&#933;	Υ
    greek capital letter phi 	&Phi;	Φ 	&#934;	Φ
    greek capital letter chi 	&Chi;	Χ 	&#935;	Χ
    greek capital letter psi 	&Psi;	Ψ 	&#936;	Ψ
    greek capital letter omega 	&Omega;	Ω 	&#937;	Ω
    greek small letter alpha 	&alpha;	α 	&#945;	α
    greek small letter beta 	&beta;	β 	&#946;	β
    greek small letter gamma 	&gamma;	γ 	&#947;	γ
    greek small letter delta 	&delta;	δ 	&#948;	δ
    greek small letter epsilon 	&epsilon;	ε 	&#949;	ε
    greek small letter zeta 	&zeta;	ζ 	&#950;	ζ
    greek small letter eta 	&eta;	η 	&#951;	η
    greek small letter theta 	&theta;	θ 	&#952;	θ
    greek small letter iota 	&iota;	ι 	&#953;	ι
    greek small letter kappa 	&kappa;	κ 	&#954;	κ
    greek small letter lambda 	&lambda;	λ 	&#955;	λ
    greek small letter mu 	&mu;	μ 	&#956;	μ
    greek small letter nu 	&nu;	ν 	&#957;	ν
    greek small letter xi 	&xi;	ξ 	&#958;	ξ
    greek small letter omicron 	&omicron;	ο 	&#959;	ο
    greek small letter pi 	&pi;	π 	&#960;	π
    greek small letter rho 	&rho;	ρ 	&#961;	ρ
    greek small letter final sigma 	&sigmaf;	ς 	&#962;	ς
    greek small letter sigma 	&sigma;	σ 	&#963;	σ
    greek small letter tau 	&tau;	τ 	&#964;	τ
    greek small letter upsilon 	&upsilon;	υ 	&#965;	υ
    greek small letter phi 	&phi;	φ 	&#966;	φ
    greek small letter chi 	&chi;	χ 	&#967;	χ
    greek small letter psi 	&psi;	ψ 	&#968;	ψ
    greek small letter omega 	&omega;	ω 	&#969;	ω
    greek small letter theta symbol 	&thetasym;	ϑ 	&#977;	ϑ
    greek upsilon with hook symbol 	&upsih;	ϒ 	&#978;	ϒ
    greek pi symbol 	&piv;	ϖ 	&#982;	ϖ
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
    euro sign 	&euro;	€ 	&#8364;	€
  
  
  ## Quotes / apostrophes
  q <- gsub(pattern = "’|`", replacement = "'", x = q)
  q <- gsub(pattern = "“|”", replacement = '"', x = q)
  ## Dashes / symbols
  q <- gsub(pattern = "—|−|–", replacement = "-", x = q)
  q <- gsub(pattern = "×", replacement = "*", x = q)
  q <- gsub(pattern = "·", replacement = ".", x = q)
  q <- gsub(pattern = "…", replacement = "...", x = q)
  ## Spaces
  q <- gsub(pattern = "­", replacement = " ", x = q)
  ## Letters
  q <- gsub(pattern = "ﬁ", replacement = "fi", x = q)
  q <- gsub(pattern = "ö|ó|ò", replacement = "o", x = q)
  q <- gsub(pattern = "ë|é|è", replacement = "e", x = q)
  q <- gsub(pattern = "ä|á|à|å", replacement = "a", x = q)
  q <- gsub(pattern = "ü|ú|ù", replacement = "u", x = q)
  
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



