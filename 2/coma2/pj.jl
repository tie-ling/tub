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
    # Spieler am Zug
    active::Symbol

    # Verbleibende Steine
    board::Int

    # mögliche Züge
    moves::Vector{Dict{Int, Real}}

    # Zustände nach einer Zug
    children::Dict{Int, Nim}
end

function createChildren(
    node::Nim,
    players::Vector{Symbol},
    winCondition::Function)::Dict{Int, Nim}

    activePlayer = node.active
    if activePlayer == players[1]
        nextPlayer = 2
    else
        nextPlayer = 1
    end

    result = Dict{Int, Nim}()

    nextMoveKey = collect(keys(node.moves[nextPlayer]))
    nextMoveFlag = Dict{Int, Bool}()
    for move in nextMoveKey
        if node.moves[nextPlayer][move] > 0
            get!(nextMoveFlag, move, true)
        else
            get!(nextMoveFlag, move, false)
        end
    end

    # falls keine Züge mehr gibt, terminiert die Funktion
    nextMovePossible = false
    for move in nextMoveKey
        if nextMoveFlag[move]
            nextMovePossible = true
        end
    end
    if !nextMovePossible
        return result
    end

    nextMoveValue = Dict{Int, Vector{Dict{Int, Real}}}()
    for move in nextMoveKey
        newMoves = copy(node.moves)
        newMoves[nextPlayer][move] -= 1
        get!(nextMoveValue, move, newMoves)
    end

    # falls node bereits gewinnen ist, terminiert die Funktion
    if winCondition(node)
        return result
    end

    for move in nextMoveKey
        if nextMoveFlag[move]
            child = Nim(players[nextPlayer], node.board - move,
                        nextMoveValue[move], Dict{Int, Nim}())
            child.children = createChildren(child, players,
                                            winCondition)
            get!(result, move, child)
        end
    end

    return result
end

function AlphaBeta(node::Nim, players::Vector{Symbol},
                   winCondition::Function,
                   alpha::Int = -1,
                   beta::Int = 1)::Int
    # firstPlayer ist maxPlayer
    firstPlayer = players[1]

    left = get(node.children, 1, nothing)
    right = get(node.children, 2, nothing)

    if winCondition(node)
        if node.active == firstPlayer
            return -1
        else
            return 1
        end
    end

    if (left == nothing) && (right == nothing)
        # unentschieden, falls [winCondition nicht erfüllt] UND [keine Züge mehr]
        return 0
    end

    if node.active == firstPlayer
        value = -1
        for child in [left, right]
            value = max(alpha, AlphaBeta(child, players, winCondition,
                                         alpha, beta))
            if value >= beta
                break
            end
        end
        alpha = max(alpha, value)
        return alpha
    else
        value = 1
        for child in [left, right]
            value = min(alpha, AlphaBeta(child, players, winCondition,
                                         alpha, beta))
            if alpha >= value
                break
            end
        end
        beta = min(beta, value)
        return beta
    end
end

function MinMax(node::Nim, players::Vector{Symbol}, winCondition::Function)::Int
    # firstPlayer ist maxPlayer
    firstPlayer = players[1]

    left = get(node.children, 1, nothing)
    right = get(node.children, 2, nothing)

    if winCondition(node)
        if node.active == firstPlayer
            return -1
        else
            return 1
        end
    elseif (left == nothing) && (right == nothing)
        # unentschieden, falls [winCondition nicht erfüllt] UND [keine Züge mehr]
        return 0
    else
        if node.active == firstPlayer
            return max((if left == nothing; -1; else MinMax(left, players, winCondition); end),
                       (if right == nothing; -1; else MinMax(right, players, winCondition); end))
        else
            return min((if left == nothing; 1; else MinMax(left, players, winCondition); end),
                       (if right == nothing; 1; else MinMax(right, players, winCondition); end))
        end
    end
end


Base.hash(a::Nim, h::UInt = 0xd42bad54a8575b16) = hash((a.board,
    a.active, a.moves), h)
Base.isequal(a::Nim, b::Nim) = (Base.hash(a) == Base.hash(b))

function dedupStates(
    node::Nim,
    hashTable::Vector{UInt64},
    players::Vector{Symbol},
    winCondition::Function)::Dict{Nim, Real}

    left = get(node.children, 1, nothing)
    right = get(node.children, 2, nothing)

    result = Dict{Nim, Real}()

    if left != nothing
        leftHash = Base.hash(left)
        if leftHash ∉ hashTable
            append!(hashTable, leftHash)
            get!(result, left, MinMax(left, players, winCondition))
            merge!(result, dedupStates(left, hashTable, players, winCondition))
        end
    end
    if right != nothing
        rightHash = Base.hash(right)
        if rightHash ∉ hashTable
            append!(hashTable, rightHash)
            get!(result, right, MinMax(right, players, winCondition))
            merge!(result, dedupStates(right, hashTable, players, winCondition))
        end
    end
    return result
end

mutable struct GlobalState
    # Spieler [:P1, :P2]
    players::Vector{Symbol}

    # mögliche Züge der Spieler
    # Anzahl der Stein und wie oft dieser Zug ausgeführt
    moves::Vector{Dict{Int, Real}}

    # test, ob gewonnen ist
    # Eingabe struct Nim
    winCondition::Function

    # Wurzel des Spielbaums
    root::Nim

    # aller möglichen Boardstates
    gameStates::Dict{Nim, Real}


    function GlobalState(
        players::Vector{Symbol},
        moves::Vector{Dict{Int, Real}},
        winCondition::Function,
        board::Int)

        # das erste Element disese Vektors ist der Startspieler
        firstPlayer = players[1]

        root = Nim(firstPlayer, board, moves, Dict{Int, Nim}())
        root.children = createChildren(root, players, winCondition)
        hashTable = Vector{UInt64}()
        gameStates = dedupStates(root, hashTable, players, winCondition)

        new(players, moves, winCondition, root, gameStates)
    end
end

function minMax(gState::GlobalState, state::Nim)::Real
    MinMax(state, gState.players, gState.winCondition)
end

function alphaBeta(gState::GlobalState, state::Nim)::Real
    AlphaBeta(state, gState.players, gState.winCondition)
end

function testy()

    players = [:P1, :P2]
    winCondition = (game::Nim)->game.board <= 0
    board = 482
    moves = Dict{Int64, Real}[
        Dict(6 => Inf, 11 => Inf, 9 => Inf), Dict(3 => Inf)]
    game = GlobalState(players, moves, winCondition, board)

    players = [:P1, :P2]
    winCondition = (game::Nim)->game.board <= 0
    board = 28779
    moves = Dict{Int64, Real}[
        Dict(1 => Inf, 2 => Inf), Dict(1 => Inf, 2 => Inf)]
    game = GlobalState(players, moves, winCondition, board)

    MinMax(game.root, game.players, game.winCondition, game.gameStates)

    root.children = createChildren(root, players, winCondition)


    game = GlobalState(players, moves, winCondition, board)
end
# Any[[:P1, :P2], Dict{Int64, Real}[Dict(6 => Inf, 11 => Inf, 9 => Inf), Dict(3 => Inf)], 482]
node = game.root; players = game.players; winCondition  = game.winCondition; gameStates = game.gameStates
