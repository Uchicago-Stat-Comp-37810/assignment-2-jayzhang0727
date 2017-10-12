#For the questions: the variable car_pool_capacity was not defined. So it will not return any values.
#It is unnecessary to use the floating number to describe an integer since our computation only involves product, sum or subtraction.

cars = 100 #This gives the total number of cars which is 100.
space_in_a_car = 4 #This gives the number of seats within a car.
drivers = 30 #This gives the total number of drivers in this system.
passengers = 90 #This gives the total number of passengers in this system.
cars_not_driven = cars - drivers #This gives the number of cars that are not driven.
cars_driven = drivers #This gives the number of cars that are being used which is obvious equal to the number of drivers.
carpool_capacity = cars_driven * space_in_a_car #This gives the total capacity of the systems which equal to the number of cars being used * the seats in each car.
average_passengers_per_car = passengers / cars_driven #This gives the average number of passengers sitted on each driven car.

#The following codes output the summary of the above datas.
print ("There are", cars, "cars available.")
print ("There are only", drivers, "drivers available.")
print ("There will be", cars_not_driven, "empty cars today.")
print ("We can transport", carpool_capacity, "people today.")
print ("We have", passengers, "to carpool today.")
print ("We need to put about", average_passengers_per_car, "in each car.")


