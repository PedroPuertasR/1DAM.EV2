/*let primerParrafo = document.getElementById("primero");
alert(primerParrafo.innerHTML);*/

let parrafos = document.querySelectorAll('p');

for(let p of parrafos){
    p.innerHTML = prompt("Dime el contenido");
}