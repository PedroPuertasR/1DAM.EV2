/*
alert('Hola que tal.');

let miArray = [0, 1, 2, 3, 4];

miArray.push


let variable;

if(loquesea){
    variable = 3;
}else{
    variable = 0;
}

let variable = (loquesea != 0) ? 3:0;
*/


//For in -> Para recorrer objetos, recorre todas las variables de estos (evitarlo)

//For of -> Para recoger elementos de un array
/*
let language = "JavaScript";
let texto = "";

for (let letra of lenguaje) {
    texto += letra + "<br\>"
    alert(texto);
}
*/

//Ejercicio 2
/*
let mensaje = ('Hola que ase.');

alert(mensaje);

//Ejercicio 3

let meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

for (let mes of meses) {
    alert(mes);
}
*/
//Ejercicio 4

//Para comparar Strings se coge como referencia la posición en el alfabeto
/*
let valores = [true, 5, false, 'Hola', 'Adios', 2];

if(valores[3] > valores [4]){
    alert(valores[3] + " es mayor que " + valores [4]);
}else if(valores[3] < valores [4]){
    alert(valores[4] + " es mayor que " + valores[3]);
}else{
    alert(valores[3] + " es igual que " + valores[4]);
}

alert(valores[0]&&valores[2]);
*/

//Calcular DNI - Ejercicio 6

/*var letras = ['T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D', 'X', 'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H', 'L', 'C', 'K', 'E', 'T'];

let num = prompt("Por favor, introduzca el número de DNI (sin letra):");
let letra = prompt("Por favor, indique la letra del DNI:")
*/

/*if(numDni >= 0 && numDni <= 99999999){
    //num correcto
    let letraDni = prompt("Por favor, indique la letra del DNI:")
    if(letraDni.length == 1 && letras.includes(letraDni)){
        let resto = numDni%23;
        let letraCalculada = letras [resto];
        if(letraCalculada === letraDni){
            alert("Su letra es correcta");
        }else{
            alert("Ha introducido una letra incorrecta.");
        }
    }else{
        alert("Por favor, introduzca una letra válida.");
    }
}else{
    alert("Por favor, introduzca un número válido.")
}*/




var letras = ['T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D', 'X', 'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H', 'L', 'C', 'K', 'E', 'T'];
let incorrecto;

do{
    let num = prompt("Por favor, introduzca el número de DNI (sin letra):");
    let letra = prompt("Por favor, indique la letra del DNI:");

    let mens = (comprobarLetraDNI(num, letra));
    alert(mens);
    incorrecto = mens!=="Su letra es correcta";
}while(incorrecto);

function comprobarLetraDNI(numDni, letraDni){
    let mensaje;
    if(numDni >= 0 && numDni <= 99999999){
        //num correcto
        if(letraDni.length == 1 && letras.includes(letraDni)){
            mensaje = (letras[numDni%23]===letraDni)?"Su letra es correcta":"Ha introducido una letra no válida";
        }else{
            mensaje = "Por favor, indique una única letra de entre las posibles.";
        }
    }else{
        mensaje = "Por favor, introduzca un número válido.";
    }

    return mensaje;
}