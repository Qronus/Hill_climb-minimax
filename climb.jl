#module HillClimb

function replace(state)


		for (i,x) in enumerate(state)
			ratio = x[2]/x[3]
			
			for (j,z) in enumerate(container)
				ratio2 = z[2]/z[3]
				if ratio > ratio2 && !(z in state)
					state[i] = container[j]
					break
				end
			end
		end

return state
end


function simplehill()

tempstate = []
swapped = []	

		for (i,x) in enumerate(container)
			ratio = x[2]/x[3]
			swap = i
			for (j,z) in enumerate(container)
				ratio2 = z[2]/z[3]
				if ratio > ratio2 && !(z in swapped)
					ratio = ratio2
					swap = j
				end
			end

				
				container[i],container[swap] = container[swap],container[i]
				push!(swapped, container[i])
				
			
		end

		
		for (i,x) in enumerate(container)
			if sumit(tempstate, 2) + x[2] <= cap
			push!(tempstate,x)
			end
		end



return tempstate

end


#function to randomly generate a state
function random_restart()

    n = rand(1:length(container))
    tempstate = []

    #loop n times to add items to new tempstate - temporary state
    for i in 1:n

        while true


            item = randomize()
		
            if length(container) == length(tempstate)
	            return
                end

                if (item in tempstate)
                    continue
                else
                   tempstate = addItem(tempstate,item)

                    break
                end
	    end
                
     end
    

     #we don't want to recreate the current state 
	if tempstate == curstate

        print("random restart reached local maxima... switching to simple method")
		tempstate = simplehill()
	return tempstate
	end
     
	if tempstate in rejects || !evaluate(tempstate)
	   tempstate=random_restart()
	end

    

      


     
return tempstate
end



function randomize()
    init = rand(1:length(container))
    item = container[init]

    return item
end


#addition operator
function addItem(state,item)
    state = push!(state,item)
    return state
end


function getItem(state)

#get item that is not present in the current state
item=[]
    while true
        item = randomize()
        if !(item in state)
        break
         end
    end

     return item
end




function climb()

    
    tempstate = deepcopy(curstate)
	

done = []
operations = 0

while true

	if length(container) == length(tempstate)
	return
	end

	if operations == 0
		done = []
		tempstate=replace(tempstate)
		operations = length(container) - length(tempstate)
	continue
	end

    item = getItem(tempstate) #generate a randomized item
	if item in done
		continue
	else
	operations -= 1
	end
    
     
         tempstate = addItem(tempstate,item)  #adding an item to the bag creates a new state
         
         
            if !evaluate(tempstate)   #we then evaluate it
                
		pop!(state[getidx(tempstate, item)])
                #removeItem(tempstate,item)  #undo the change and regenerate another state
		push!(done,item)
                continue

            else
                
                #get neighbour state by random restart
                nxstate = random_restart()


                 #compare the 2 states
                 println("comparing current state to new state")
                 if sumit(nxstate, 3) > sumit(tempstate, 3)
                    global curstate = nxstate
                    break
                 else
                    global curstate = tempstate
                    break
                end


            end


end
            

return
end


#evaluates a state and returns true if it's part of the solution
function evaluate(bag)
println("evaluating state")
weights = 0;

    #sum item weights in the bag
   weights = sumit(bag, 2)
   

   
    if weights > cap    #check if bag capacity is reached
        push!(rejects,bag)
        return false

    else    
        if(heuristic(bag))  #find value heuristics
            return true

        else
            push!(rejects,bag)
            return false
        end
    end

        

end




#returns a heuristic value of a state
function heuristic(state)
# goal ==    W <= x <= V  whereby x is the bag, W the weight capacity and v the total item's value

H = false

    if sumit(state, 3) > sumit(curstate, 3)
        return true

    elseif sumit(state, 3) == sumit(curstate, 3)   #avoiding plateu
       if sumit(state, 2) < sumit(curstate,2)   #return if value i equal to currentstate's but weight is better than current state
            return true

        else
             return false
        end

    else
        return false
    end


return H
end




#sums array values and returns elms-elements sum
function sumit(A,indx)
elms = 0

    if length(A) < 1
        return elms
    end

    for (i,x) in enumerate(A)
        elms += x[indx]
    end

return elms
end



#driver code
function start()


global curstate = []
global nxstate = []
global bad = []
global rejects = []

global items = 0 #holds total number of items


global cap = 0  #holds weight limit


global container = Vector{Any}(undef, items) #array containing all item vectors





    print("Knapsack problem solver using Hill climb\n\n")

    print("How many items do you have: ")
   global items = parse(Int64,readline())

    print("\n\nWhat is the bag's total capacity (weight): ")
    global cap = (parse(Int64,readline()))



    #loop to get and add items in container
    for i = 1:items

        print("\nenter details for item $i in the format (name,weight,value): ")
        item = split(readline(),",")
        
         item = [item[1],parse(Int, item[2]),parse(Int, item[3])]

	if item[2] < cap
        	push!(container, item)    #add item to container
	else
		push!(bad, item)
	end

    end


end




#quits
function stop()

     println("\n\n\t\tThe best solution found:\n\nTotal value: ",sumit(curstate,3),"\nTotal weight: ",sumit(curstate,2),"\nTotal items: ",length(curstate)) 
    println("\nItems is the sack\n")

   
    for i in eachindex(curstate)
             println("name = ",curstate[i][1],"  value = ",curstate[i][3],"  weight = ",curstate[i][2])
        
    end
	if length(rejects) > 1 
    print("\n\nrejected solutions generated by random restart\n\nstate\tValue\tWeight\titems\n")

    for (i,x) in enumerate(rejects)
        println(i,"\t ",rejects[i][3],"\t  ",rejects[1][2],"\t  ",length(x))
         end
	end

end



function getidx(arr, arr2)
           if length(arr) < 1
               error: "Array does not have elements"
           else
           found = false
               for i = 1:length(arr)
                   if arr2 == arr[i]
                       return i

                   end
               end
           end
           return found
        

end




#initializer loop
start()

while true
println("which method do you want to use:\n\n\t1.random restart\n\t2.simple hill climb\n")
print("enter option (number) : ")
inp = readline()

    if inp == "2"
        print("solving with simple method")
        global curstate = simplehill()
       break

    elseif inp == "1"
         print("genearating state with random restart")
        global curstate = random_restart() #initialize state
     
         climb() #start hillclimb algo if initial state is valid
        break
     else
        print("\t\tinvalid input!\n\n")
        sleep(1)
        continue
    end


end
stop()


#end  of module