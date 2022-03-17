= Criar import de Categorias
= usar money para carro
- criar update de carros e nao permitir atualizar a placa
====
# Cars

## DB Informations

**cars**
name description daily_rate:integer available:boolean license_plate:unique fine_amount:integer brand category_id:references:categories

**specifications_cars**
id car_id:references:cars specification_id:references:specifications

**cars_image**
id car_id:references:cars image

**rentals**

- id car_id:references:cars user_id:references:users start_date:date end_date:date expected_return_date:date total:integer 

## Insert/Update a Car

**FR**
- [x] Should insert a new Car
- [x] Should be possible list all categories

**NFR**

-NTD-

**ACs**

- [x]] Should not be possible insert a new car with the same **license_plate**
- [ ] Should not be possible to update **license_plate** for a car that already exist
- [x] Should be inserted with **available** true 
- [x] Only Admin can insert/update a new car

## List Cars

**FR**
- [ ] List all available cars
- [ ] Should be possible filter cars by categories name
- [ ] Should be possible filter cars by brand name
- [ ] Should be possible filter cars by name

**NFR**

-NTD-

**ACs**

- [ ] User does not necessary signed in the system


## Insert Car Especification

**FR**
- [ ] Should be possible insert an specification for a car
- [ ] Should be possible possible list all specifications
- [ ] Should be possible list all cars

**NFR**

-NTD-

**ACs**

- [ ] Car should be available to insert specifications
- [ ] Should not be possible insert an specification that already exist in a car
- [ ] Only Admins can execute this operation



## Insert Car`s image

**FR**
- [ ] Should be possible insert multiple image cars
- [ ] Should be possible list all cars

**NFR**

- use **waffle**

**ACs**

- [ ] Can be possible to insert more than one image to the same car
- [ ] Only Admin can execute this operation


## Rent Cars

**FR**
- [ ] Should be possible insert multiple image cars
- [ ] Should be possible list all cars

**NFR**

- use **waffle**

**ACs**

- [ ] Can be possible to insert more than one image to the same car
- [ ] Only Admin can execute this operation


## Book Cars

**FR**
- [ ] Should be possible book a car

**NFR**

- NTD - 

**ACs**

- [ ] To book a car must be at least 24 hours
- [ ] Should not be possibleto book a car is already exist to the same car
  