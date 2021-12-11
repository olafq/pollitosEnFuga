% 1. Desarrollar los predicados necesarios para modelar a los animales y las granjas descritas.
%gallina(Nombre,Peso,CantHuevos).
gallina(ginger,10,5).
gallina(babs,15,2).
gallina(mac,8,7).
gallina(bunty,23,6).
gallina(turuleca,15,1).
%gallo(Nombre,Profesion).
gallo(rocky,animalDeCirco).
gallo(fowler, piloto).
gallo(oro, arrocero).
%rata(Nombre)
rata(nick).
rata(fetcher).

granja(Granja) :-
    viveEn(Granja,_).

viveEn(delSol,turuleca).
viveEn(delSol,oro).
viveEn(delSol,nick).
viveEn(delSol,fetcher).

viveEn(tweedys,ginger).
viveEn(tweedys,babs).
viveEn(tweedys,bunty).
viveEn(tweedys,mac).
viveEn(tweedys,fowler).


esAnimal(Animal):-
    gallina(Animal,_,_).
esAnimal(Animal):-
    gallo(Animal,_).
esAnimal(Animal):-
    rata(Animal).

%2. puedeCederle/2: nos dice si una gallina puede cederle huevos a otra. 
%Las gallinas más trabajadoras se solidarizan con las haraganas: una que pone 7 huevos semanales puede cederle huevos a aquellas que ponen menos de 3.
puedeCederle(Gallina,OtraGallina) :-
    gallinaTrabajadora(Gallina),
    gallinaHaragana(OtraGallina).

gallinaTrabajadora(Gallina) :-
    gallina(Gallina,_,7).
gallinaHaragana(Gallina) :-
    gallina(Gallina,_,Huevos),
    Huevos < 3.

%3. animalLibre/1: un animal es libre cuando no vive en ninguna granja.
animalLibre(Animal) :-
    esAnimal(Animal),
    not(viveEn(_,Animal)).

%4. valoracionDeGranja/2: relaciona a una granja con su valoración, que se calcula como la suma de la valoración de sus animales. 
%Cada animal tiene una valoración distinta:
%las ratas valen 0;
%los gallos valen 50 si saben volar, o 25 si no;
%las gallinas valen su peso multiplicado por la cantidad de huevos semanales.
%Tené en cuenta que los gallos saben volar si son pilotos o animales de circo.
valoracionDeGranja(Granja,ValoracionGranja) :-
    granja(Granja),
    findall(ValoracionAnimal, valoracionDeQuienVivenEn(Granja,ValoracionAnimal), ValoracionDeAnimalesGranja),
    sumlist(ValoracionDeAnimalesGranja, ValoracionGranja).

valoracionDeQuienVivenEn(Granja,ValoracionAnimal) :-
viveEn(Granja,Animal),
valoracionAnimal(Animal,ValoracionAnimal).

valoracionAnimal(Animal,0):-
    rata(Animal).

valoracionAnimal(Animal,50):-
    gallo(Animal,Profesion),
    puedeVolar(Profesion).

valoracionAnimal(Animal,25):-
    gallo(Animal,Profesion),
    not(puedeVolar(Profesion)).

valoracionAnimal(Animal,Valor):-
    gallina(Animal,Peso,CantHuevos),
    Valor is Peso * CantHuevos.

puedeVolar(piloto).
puedeVolar(animalDeCirco).

%5. granjaDeluxe/1: las granjas de lujo son aquellas que están libres de ratas y además:
%tienen más de 50 animales, o bien su valoración es exactamente 1000.
granjaDeluxe(Granja) :-
    granja(Granja),
    estaLibreDeRatas(Granja),
    granjaPiola(Granja).

estaLibreDeRatas(Granja) :-
    rata(Animal),
    not(viveEn(Granja,Animal)).

granjaPiola(Granja) :-
    tieneMuchasAnimales(Granja).
granjaPiola(Granja) :-
    valoracionDeGranja(Granja,1000).

tieneMuchasAnimales(Granja) :-
    granja(Granja),
    findall(Animal, viveEn(Granja,Animal), Animales),
    length(Animales,TotalAnimales),
    TotalAnimales > 4.

%6. buenaPareja/2: dos animales hacen buena pareja cuando viven en una misma granja y:
%si son dos gallinas, una gallina le puede ceder huevos a la otra y ambas pesan lo mismo;
%si son dos gallos, sólo uno de los gallos sabe volar; 
%y si son dos ratas, siempre hacen buena pareja.
buenaPareja(Animal,OtroAnimal) :-
    esAnimal(Animal),
    esAnimal(OtroAnimal),
    viveEnUnaMismaGranja(Animal,OtroAnimal),
    esBuenaParejaDe(Animal,OtroAnimal).

esBuenaParejaDe(Animal,OtroAnimal) :-
    tipoDeCondicionPorAnimal(Animal,OtroAnimal).
esBuenaParejaDe(Animal,OtroAnimal) :-
    tipoDeCondicionPorAnimal(OtroAnimal,Animal).

tipoDeCondicionPorAnimal(Gallina,OtraGallina) :-
    gallina(Gallina,Peso,_),
    gallina(OtraGallina,Peso,_),
    puedeCederle(Gallina,OtraGallina).

tipoDeCondicionPorAnimal(Gallo,OtroGallo) :-
    gallo(Gallo,Profesion),
    gallo(OtroGallo,OtraProfesion),
    puedeVolar(Profesion),
    not(puedeVolar(OtraProfesion)).


tipoDeCondicionPorAnimal(Rata,OtraRata) :-
    rata(Rata),
    rata(OtraRata).


viveEnUnaMismaGranja(Animal,OtroAnimal) :-
    viveEn(Granja,Animal),
    viveEn(Granja,OtroAnimal),
    Animal \= OtroAnimal.


%7. escapePerfecto/1: para escapar hay que tener huevos. 
%Una granja puede realizar un escape perfecto cuando todas sus gallinas ponen más de cinco huevos por semana y todos sus animales hacen buena pareja con algún otro.
escapePerfecto(Granja) :-
    tieneHuevos(Granja).

tieneHuevos(Granja) :-
    granja(Granja),
    forall(gallinaQueViveEn(Granja,Gallina), gallinaPonedora(Gallina)),
    forall(viveEn(Granja,Animal),buenaPareja(Animal,_)).


gallinaQueViveEn(Gallina,Granja) :-
    gallina(Gallina,_,_),
    viveEn(Granja,Gallina).
gallinaPonedora(Gallina) :-
    gallina(Gallina,_,Huevos),
    Huevos < 5.
    

    
   





