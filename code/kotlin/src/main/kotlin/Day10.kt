import java.nio.file.Paths


val SIGNAL_STRENGTHS = arrayListOf<Int>(20, 60, 100, 140, 180, 220) ;



class CRT {
    val results = mutableListOf<Int>();
    var X = 1;
    var numberCycle = 0
    var update = 0;
    var historySpritePosition = mutableListOf<Int>();

    private fun calculateSignalStrength(): Int? {
        val signal = numberCycle + 1;
        if (SIGNAL_STRENGTHS.contains(signal)) {
            val result = X * signal;
            return result;
        }
        return null;
    }

    private fun add (value: String) {
        //add operation
        for (index in 0..1) {
            this.historySpritePosition.add(X);
            numberCycle+=1;

            //End of cycle
            if (index == 0)  {
                update = value.split(" ")[1].toInt()
            } else {
                X+= update
            }
            calculateSignalStrength()?.let { results.add(it) }
        }
    }

    private fun noop(value: String) {
        this.historySpritePosition.add(X);
        numberCycle+=1;
        calculateSignalStrength()?.let { results.add(it) }
    }
    fun run(values: List<String>) {
        for (value in values){
            println("index=${numberCycle} value=${value}, X=${X}")
            when {
                value.startsWith("addx") -> {
                    this.add(value);
                }
                else -> {
                    this.noop(value);
                }
            }
        }
    }

    fun calculateSignal(): Int {
        return results.sum()
    }

    fun draw() {
        val numberOfCycles = this.historySpritePosition.size
        for (index in 0 until numberOfCycles) {
                val positionSprite = this.historySpritePosition.get(index);
                val cycle = (index +1) % 40
                if  (cycle in positionSprite..positionSprite  + 2) {
                    print("#")
                } else {
                    print(".")
                }
            if ((index+1) % 40 == 0) {
                print("\n")
            }
         }
    }
}


fun main(args: Array<String>) {
    var filename = "day10.txt"
    if (args.size >= 2)  {
        filename = args[1]
    }
    val path = System.getProperty("user.dir")
    val filepath = Paths.get(/* first = */ path, /* ...more = */ filename)
    val values = filepath.toFile().readLines();
    val crt = CRT();
    println(values.size)
    crt.run(values);
    val results = crt.calculateSignal();
    println(results)
    println(crt.historySpritePosition.size)
    crt.draw()
}