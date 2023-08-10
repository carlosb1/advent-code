import java.nio.file.Paths

fun main(args: Array<String>) {

    println("Program arguments: ${args.joinToString()}")

    var filename = "default.txt"
    if (args.size >= 2)  {
        filename = args[1]
    }

    val path = System.getProperty("user.dir")
    val filepath = Paths.get(/* first = */ path, /* ...more = */ filename)
    val values = filepath.toFile().readLines();
    val currentCarries = mutableListOf<UInt>()
    var topCarries = mutableListOf<UInt>()
    for (value in values) {
        if (value == "") {
            val sumValues = currentCarries.sum();
            if (topCarries.size < 3 || topCarries.any { it < sumValues}) {
                topCarries.add(sumValues)
                topCarries = topCarries.sorted().takeLast(3).toMutableList()
            }
            currentCarries.clear()
        } else {
            currentCarries.add(value.toUInt())
        }
    }
    println("values : ${topCarries.sum()}")
}