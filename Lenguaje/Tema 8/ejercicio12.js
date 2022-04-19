//Crea una función que reciba un array con números y los ordene de mayor a menor.

let array = [1, 4, 6, 2, 5, 10];

function ordenar(array) {
    let max = new Array(array.length);
    let tam = array.length;
    let num = 0;
    for (let j = 0; j < tam; j++) {
        for (let i = 0; i < array.length; i++) {
            max[j] = 0;
            if(max[j] < array[i]){
                num = array[i];
                array[i] = 0;
            }
        }
        max[j] = num;
    }
    return max;
}

let arrayMostrar = ordenar(array);

for (let index = 0; index < array.length; index++) {
    alert(arrayMostrar[index]);
}
    