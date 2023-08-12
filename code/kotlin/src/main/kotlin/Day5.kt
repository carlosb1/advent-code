import java.nio.file.Paths
import java.util.ArrayDeque


fun totalCols(line: String): Int{
    return ((line.length + 1) / 4)
}

fun findIndexes(line: String): MutableList<Int> {
    val indexes: MutableList<Int> = mutableListOf<Int>()
    var index = line.indexOf("[")
    while (index >=0)  {
        indexes.add(index)
        index = line.indexOf("[", index+1)
    }
    return indexes;
}

fun parseMovement(line: String): Triple<Int, Int, Int> {
    val split = line.split(" ")
    return Triple(split[1].toInt(), split[3].toInt() -1 , split[5].toInt() -1)
}

fun main(args: Array<String>) {
    var filename = "day5.txt"
    if (args.size >= 2)  {
        filename = args[1]
    }

    val path = System.getProperty("user.dir")
    val filepath = Paths.get(/* first = */ path, /* ...more = */ filename)
    val values = filepath.toFile().readLines();
    val numberCols = totalCols(values.first())
    println("Number of cols: ${numberCols}")

    val sizeGraph = values.indexOf("") - 1 ;
    println("size graph: ${sizeGraph}");

    val board: MutableList<ArrayDeque<Char>> = MutableList(numberCols) {ArrayDeque()}

    values.take(sizeGraph).map { line ->
        val listIndexes = findIndexes(line).map {
            val numberCol = (it / 4) + 1
            val namePiece = line[it+1]
            Pair(numberCol, namePiece)
        }.forEach { piece ->
            val index = piece.first - 1
            board[index].push(piece.second)
        }
    }
    println(board)
    values.drop(sizeGraph + 2).map {
        val movement  = parseMovement(it)
        movement
    }.forEach { movement ->
        move2(board, movement)
    }

    val result = board.map {
        it.last()
    }.joinToString("")
    println(result)
}

fun move(board: MutableList<ArrayDeque<Char>>, movement: Triple<Int, Int, Int>) {
    (1..movement.first).map {
        println(movement)
        board[movement.third].addLast(board[movement.second].pollLast());
        println(board)
    }
}

fun move2(board: MutableList<ArrayDeque<Char>>, movement: Triple<Int, Int, Int>) {
    val toInsert = ArrayDeque<Char>()
    (1..movement.first).map {
        toInsert.addFirst(board[movement.second].pollLast());
    }
    toInsert.map {
        println(movement)
        board[movement.third].addLast(it);
        println(board)
    }
}

