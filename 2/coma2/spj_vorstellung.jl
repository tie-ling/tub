# Yiwen Yang 466096, Yuchen Guo 480788, Qing Wang 458040


# Analyse von Nim-Spiel
#
# Zwei Spieler, Abwechselnd Steine von einem Stapel ziehen.
# Wer den letzten Stein gezogen hat, ist gewonnen.

# Zwei Spieler sind :P1 und :P2
# Man darf entweder eine Stein oder zwei Steine nehmen.

# Falls P1 gewinnt, setzt positiv Eins
# Falls P2 gewinnt, setzt negativ Eins

mutable struct Nim
    active::Symbol
    board::Int
    moves::Vector{Dict{Int, Real}}
    # children leer
    children::Dict{Int, Nim}
end

function getCurrentPlayer(node::Nim, players::Vector{Symbol})::Int
    if node.active == players[1]
        return 1
    else
        return 2
    end
end

function getNextMoves(node::Nim, players::Vector{Symbol})::Vector{Int}
    activePlayer = getCurrentPlayer(node, players)
    nextKeys = collect(keys(node.moves[activePlayer]))
    resultKeys = Vector{Int}()
    for key in nextKeys
        if (node.moves[activePlayer][key] > 0)
            push!(resultKeys, key)
        end
    end
    return resultKeys
end


function getNextPlayer(node::Nim, players::Vector{Symbol})::Int
    if node.active == players[1]
        return 2
    else
        return 1
    end
end

Base.hash(a::Nim, h::UInt = 0xd42bad54a8575b16) = hash((a.board,
    a.active, a.moves), h)
Base.isequal(a::Nim, b::Nim) = ((a.board == b.board) && (a.active ==
    b.active) && (a.moves == b.moves))

function createStates(node::Nim,
                      gameStates::Dict{Nim, Real},
                      players::Vector{Symbol},
                      winCondition::Function)
    nextKeys = getNextMoves(node, players)
    nextPlayer = getNextPlayer(node, players)
    nextPlayerSymbol = players[nextPlayer]

    # falls unentschieden
    # next == []
    if nextKeys == []
        newNode = deepcopy(node)
        if newNode.active == players[1]
            newNode.active = players[2]
        else
            newNode.active = players[1]
        end
        nextNextKeys = getNextMoves(newNode, players)
        # nextnext == []
        if nextNextKeys == []
            gameStates[node] = 0
        else
            node = newNode
            get!(gameStates, node, 6)
            nextKeys = nextNextKeys
            nextPlayer = getNextPlayer(node, players)
            nextPlayerSymbol = players[nextPlayer]
        end
    end


    for key in nextKeys
        newMoves = node.moves
        currentPlayer = getCurrentPlayer(node, players)
        newMoves[currentPlayer][key] -= 1
        newNode = Nim(nextPlayerSymbol, node.board - key, newMoves,
                      Dict{Int, Nim}())
        if winCondition(newNode)
            if nextPlayerSymbol == players[1]
                get!(gameStates, newNode, -1)
            else
                get!(gameStates, newNode, 1)
            end
        else
            get!(gameStates, newNode, 6)
        end
    end
end

mutable struct GlobalState
    players::Vector{Symbol}
    moves::Vector{Dict{Int, Real}}
    winCondition::Function
    root::Nim
    gameStates::Dict{Nim, Real}
    function GlobalState(
        players::Vector{Symbol},
        moves::Vector{Dict{Int, Real}},
        winCondition::Function,
        board::Int)

        firstPlayer = players[1]

        root = Nim(
            firstPlayer,
            board,
            moves,
            # node.children, leer
            Dict{Int, Nim}())

        gameStates = Dict{Nim, Real}()

        get!(gameStates, root, 6)

        AlphaBeta(root, gameStates, players, winCondition)

        new(players, moves, winCondition, root, gameStates)
    end
end

function MinMax(
    node::Nim,
    players::Vector{Symbol},
    gameStates::Dict{Nim, Real})::Int

    value = gameStates[node]

    if value != 6
        return value
    end

    # first player is maxPlayer
    maxPlayer = players[1]

    nextKeys = getNextMoves(node, players)
    if nextKeys == []
        if node.active == players[1]
            node.active = players[2]
        else
            node.active = players[1]
        end
        nextKeys = getNextMoves(node, players)
    end

    children = Vector{Nim}()

    for key in nextKeys
        newMoves = node.moves
        currentPlayer = getCurrentPlayer(node, players)
        newMoves[currentPlayer][key] -= 1
        nextPlayer = getNextPlayer(node, players)
        nextPlayerSymbol = players[nextPlayer]
        newNode = Nim(nextPlayerSymbol, node.board - key, newMoves,
                      Dict{Int, Nim}())
        if haskey(gameStates, newNode)
            push!(children, newNode)
        end
    end

    childrenValues = Vector{Int}()
    for child in children
        if gameStates[child] == 6
            # calculate value of child
            gameStates[child] = MinMax(child, players, gameStates)
        end
        push!(childrenValues, gameStates[child])
    end

    if node.active == maxPlayer
        return maximum(childrenValues)
    else
        return minimum(childrenValues)
    end
end

function minMax(gState::GlobalState, state::Nim)::Real
    MinMax(state, gState.players, gState.gameStates)
end

function getNodeValue(node::Nim, gameStates, players, winCondition)::Int
    createStates(node, gameStates, players, winCondition)
    return gameStates[node]
end

function AlphaBeta(
    node::Nim,
    gameStates,
    players,
    winCondition,
    alpha::Int = -1,
    beta::Int = 1)::Int

    value = getNodeValue(node, gameStates, players, winCondition)

    if value != 6
        return value
    end

    # first player is maxPlayer
    maxPlayer = players[1]

    skipFlag = false
    nextKeys = getNextMoves(node, players)
    if nextKeys == []
        newNode = deepcopy(node)
        originalNode = node
        node = newNode
        skipFlag = true
        if node.active == players[1]
            node.active = players[2]
        else
            node.active = players[1]
        end
        nextKeys = getNextMoves(node, players)
    end

    children = Vector{Nim}()

    for key in nextKeys
        newMoves = node.moves
        currentPlayer = getCurrentPlayer(node, players)
        newMoves[currentPlayer][key] -= 1
        nextPlayer = getNextPlayer(node, players)
        nextPlayerSymbol = players[nextPlayer]
        newNode = Nim(nextPlayerSymbol, node.board - key, newMoves,
                      Dict{Int, Nim}())
        if haskey(gameStates, newNode)
            push!(children, newNode)
        end
    end

    if node.active == maxPlayer
        value = -1
        for child in children
            if gameStates[child] == 6
                gameStates[child] = AlphaBeta(child, gameStates, players, winCondition, alpha,
                                              beta)
            end
            value = max(alpha, gameStates[child])
            if value >= beta
                break
            end
            alpha = max(alpha, value)
        end
        result = max(alpha, value)
        gameStates[node] = result
        if skipFlag
            gameStates[originalNode] = result
        end
        return result
    else
        value = 1
        for child in children
            if gameStates[child] == 6
                gameStates[child] = AlphaBeta(child, gameStates, players, winCondition, alpha,
                                              beta)
            end
            value = min(beta, gameStates[child])
            if alpha >= value
                break
            end
            beta = min(beta, value)
        end
        result = min(beta, value)
        gameStates[node] = result
        if skipFlag
            gameStates[originalNode] = result
        end
        return result
    end
end

function alphaBeta(gState::GlobalState, state::Nim)::Real
    AlphaBeta(state, gState.gameStates, gState.players, gState.winCondition)
end

# winCondition = game -> game.board <= 0
# board = 584
# moves = Dict{Int, Real}[Dict(7 => Inf, 9 => Inf), Dict(6 => Inf, 9 => Inf)]
# players = [:P1, :P2]
# # node = Nim(:P1, board, moves, Dict{Int, Nim}())
# game = GlobalState(players, moves, winCondition, board)
# # winCondition = game -> game.board <= 0
# board = 47130
# moves = Dict{Int64, Real}[Dict(79 => Inf, 136 => Inf, 117 => Inf, 7 => Inf, 90 => Inf, 66 => Inf, 112 => Inf, 134 => Inf), Dict(5 => Inf, 59 => Inf, 13 => Inf, 35 => Inf, 67 => Inf, 50 => Inf)]
# players = [:P1, :P2]
# node = Nim(:P1, board, moves, Dict{Int, Nim}())
# game = GlobalState(players, moves, winCondition, board)

# Die Abgabe war nicht erfolgreich. Das Programm erzeugt einen fehlerhaften Output.

# Fehler in den öffentlichen Testinstanzen:
# Es wurden 55 von 100 Testinstanzen(55.0%) korrekt gelöst.
# Erste falsche Instanz:
# Input: Any[[:P1, :P2], Dict{Int64, Real}[Dict(7 => Inf, 9 => Inf), Dict(6 => Inf, 9 => Inf)], 584]
# Erwarteter Output: Player Vector: [:P1, :P2]
# Board: 584
# AlphaBeta explored the same amount of states:  true
# AlphaBeta found the same value as MinMax: true
# The value found was -1


# alphaBeta(game, game.root)

# value 1
