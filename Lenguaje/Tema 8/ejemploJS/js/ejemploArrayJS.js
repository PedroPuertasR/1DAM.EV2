function esPalindromo(cadena){
    //Espacios en blanco
    cadena = cadena.toLowerCase();
    cadena = cadena.replace(' ', '');
    let cadenaComoArray = cadena.split('');
    let cadenaArrayInversa = cadenaComoArray.reserve();
    let cadenaInversa = cadenaArrayInversa.join('');

    return cadena === cadenaInversa;
}