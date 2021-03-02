import ../components/component
import hashes

type
    SystemConcept* = concept system, component
        run(system, component) = void

    MySystem* = ref object of RootObj

method run*(system: MySystem, component: Component): void = 
    echo "I am not implemented!"

proc hash*(system: MySystem): Hash = "MySystem".hash()