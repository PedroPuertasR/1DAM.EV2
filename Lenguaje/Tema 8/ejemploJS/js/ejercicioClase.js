let tam = +prompt('Indique el tamaño del array');
let array = new Array(tam);
let suma = 0;

for (let index = 0; index < tam; index++) {
    array[index] = +prompt('Indique el valor');
}

for (let index = 0; index < tam; index++) {
    alert('Número ' + index + ' = ' + array[index]);
}

function sumar(){
    for (let index = 0; index < tam; index++) {
        suma += array[index];
    }
    return suma;
}

alert('El total de la suma es: '+ sumar());

