import java.nio.file.Path
import java.nio.file.Paths


fun main(args: Array<String>) {
    var filename = "day7b.txt"
    if (args.size >= 2)  {
        filename = args[1]
    }

    val directory: MutableMap<Path, UInt> = mutableMapOf()
    var currentPath: Path = Paths.get("/")
    var listingFile = false;

    val path = System.getProperty("user.dir")
    val filepath = Paths.get(/* first = */ path, /* ...more = */ filename)
    val values = filepath.toFile().readLines();
    for (value in values) {
         when {
            value == "$ cd /" -> {
                currentPath = Paths.get("/")
                listingFile = false
            }
            value.startsWith("$ cd") -> {
                val result = value.split("$ cd ")[1];
                if (result == "..") {
                    //FIXME  educational purposes, it doesn need check here.
                    currentPath = currentPath.parent!!
                } else {
                    currentPath = currentPath.resolve(result)
                }
                listingFile = false
            }
            value == "$ ls" -> {
                listingFile = true
            }
            value.startsWith("dir").not() && listingFile->   {
                val splitted = value.split(" ");
                val size: UInt = splitted[0].toUInt();
                val newSize = directory.getOrDefault(currentPath, 0u) + size;
                directory[currentPath] = newSize
                var parentPath = currentPath;
                while (parentPath.parent != null) {
                    parentPath = parentPath.parent!!;
                    val parentSize = directory.getOrDefault(parentPath, 0u) + size;
                    directory[parentPath] = parentSize
                }
            }

            else -> {}
        }
    }
    println(directory)

    // solution part1
    println(directory.values.filter { it  < 100000u }.sum() );


    // second part
    val currentSpace = 70000000u - directory.values.max();
    val necessarySpace = 30000000u - currentSpace;
    println(directory.values.filter { it >= necessarySpace }.sorted());
    println(directory.values.filter { it >= necessarySpace }.min());
}