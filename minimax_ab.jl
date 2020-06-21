
SIZE = 3
SEPARATOR = repeat("-",(4 * SIZE + 1))

function empty()
    # return an empty grid
    grid = Any[]
    
    return grid = [repeat(Any[" "],SIZE)  for i in range(1, stop=SIZE)] ##
end


function render(grid)

    
    #println("\n\n\n\t\t",SEPARATOR)

    for i in range(1,stop=SIZE)
        print("\n\t\t\t\t|")

        for j in range(1,stop=SIZE)

            if grid[i][j] == " "
                print(" ",(SIZE^2)-(i*SIZE-j)," |")

               

            elseif grid[i][j] == "X"
                print(" ")
                printstyled(grid[i][j],color=:green)
               print(" |")

            else
                print(" ")
                printstyled(grid[i][j],color=:red)
                print(" |")
            end

        end
println()
       # println("\n\t\t",SEPARATOR)
    end

end



function cellnum()
    return (SIZE^2)-(i*SIZE-j)
end


function win_player(grid, char)
    # check if a player wins the game
    # check rows

    for i = 1:3
        if all(grid[i][j] == char for j = 1:3)
            return true
        end
    end

    # check columns
    for j = 1:3
        if all(grid[i][j] == char for i = 1:3)
            return true
        end
    end


    # check diagonals
    if all(grid[i][i] == char for i = 1:3)
        return true
    end

    if all(grid[i][4 - i] == char for i = 1:3)
        return true
    end

    return false
end 



function coordinates(choice)
    # return the row and coloumn corresponding to user input
    # get row
    row = ceil(Int,(3-((choice + 2) // 3)))
    #get col
    col = (choice -1) % 3

    return row+1,col+1

end


function terminal(grid)

    # check if the game is at a terminal state
    # player wins
    if win_player(grid, "X")
        return true
    end

    # computer wins
    if win_player(grid, "O")
        return true
    end

    # tie
    if all(grid[i][j] != " " for i = 1:3 for j = 1:3) ##
        return true
    end
    
    # otherwise the game isn't over yet
    return false

end



function utility(grid)
    # return the score corresponding to the terminal state
    if win_player(grid, "X")
        return -1
    end

    if win_player(grid, "O")
        return 1
        ###
    
    end
return 0
end


function actions(grid)
    # return possible actions a player can take at each state
    result = Any[]

    for i in range(1,stop =SIZE)
        for j in range(1,stop =SIZE)
            if grid[i][j] == " "
                push!(result, (i, j))
                
            end
        end
   
    end
    #shuffle!(result)
    return result

end




function minimax(grid, computer, alpha, beta, depth)

    # return the maximum value a player can obtain at each step
    if terminal(grid)
        return utility(grid), depth
    end

    if computer
        m = -Inf
        char = "O"
    else
        m = Inf
        char = "X"
    end

    for action in actions(grid)
        i , j = action
        grid[i][j] = char

        value , depth = minimax(grid, !computer, alpha, beta, depth + 1)


        if computer
         m = Int(max(m, value))
        else
         m = Int(min(m, value))
        end


        # undo the move
        grid[i][j] = " "

        # alpha-beta pruning
        if computer
            alpha = max(alpha, m)
        else
            beta = min(beta, m)
        end

        if beta <= alpha
            break
        end
    end
    return m, depth

end




function best_move(grid)
     # find all empty cells and compute the minimax for each one
    m = alpha = -Inf   
    d = beta = Inf

result = 0;

    for action in actions(grid)
        i , j = action
        grid[i][j] = "O"
        value , depth = minimax(grid, false, alpha, beta, 0)


        if value > m || (value == m && depth < d)
            result = i ,j
            m = value
            d = depth
        end

        # undo the move
        grid[i][j] = " "
        
    end

    return result

end




function get_user_input(grid)
    # ask for player input : a number between 1 and 9

    while true
      #  render(grid)

        print("\n\nEnter choice (between 1-9): ")
        choice = readline()
       

        # validate input
        if !(choice in [string(i) for i in 1:9])##
            printstyled("\n\n\t\t\tinvalid choice",color=:red)
            sleep(1)
            continue
        end

         choice = parse(Int64,choice)
             i,j = coordinates(choice)

        if grid[i][j] != " "
            printstyled("\n\n\t\tThe chosen cell is already filled.",color=:red)
            sleep(1)
            render(grid)
            continue
        end


        # if cell is not full : fill with 'X'
        grid[i][j] = "X"
        break
        
    end

end




function game_loop(grid)

    #=bgn = true
    if rand(1:10) > 5=#

    while true

    

        printstyled("\n\n\t\t\t\tIt's  your turn\n\n",color=:green)
       
        # player turn
        get_user_input(grid)

        render(grid)

        # check if the player wins
        if win_player(grid, "X")
            print("\n\t\t\t\tYou win!\n",color=:cyan)
            break
        end

        # check if it's a tie
        if terminal(grid)
            println("\n\t\t\t\t    Tie!")
            break
        end

        
        # computer turn
        # find the best move to play
        i , j = best_move(grid)
        grid[i][j] = "O"


        printstyled("\n\n\t\t\t   It's the computer's turn\n\n",color=:yellow)
        sleep(2)
        # display the grid
        render(grid)

        # check if the computer wins with this choice
        if win_player(grid, "O")
            printstyled("\n\n\t\t\t\tYou lose!\n",color=:red)
            break
        end
    end

end


function play()
    while true
        grid = empty()
        render(grid)
        println("\n\n\t\twelcome to tic tac toe, good luck defeating the master")
        sleep(1)
        game_loop(grid)

         print("\n\n\t\t\tPlay again ? [y/n] ")
         again = readline()

        if uppercase(again) != "Y"
            break
        end
    end
end

play()



 function shuffle!(arr::AbstractArray)

    ind = rand(1:length(arr))
    checked = Any[]

      for i = 1:ind

         done = false
         chkd = true

         while !done
	
	        if length(checked) >= length(arr)
                return arr
            end

           tmp2 = rand(1:length(arr))
           tmp = rand(1:length(arr))

            while chkd
                   if !tmp in checked

                       if !tmp2 in checked

                           chkd = false


                       else
                           tmp2 = rand(1:length(arr))
                       end

                   else
                       tmp = rand(1:length(arr))
                   end
               end


                if tmp != tmp2

                   arr[tmp],arr[tmp2] = arr[tmp2], arr[tmp]
                   push!(checked,tmp,tmp2)
                   done = true

               end
            end
          end

     return arr
 end
