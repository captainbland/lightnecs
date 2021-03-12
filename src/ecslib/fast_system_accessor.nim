
import entity
import options

type 
    FastSystemAccessor*[CType, Sys] = tuple
        getComponent: proc (entity: Entity): CType
    
proc getFastSystemAccessor*[CType, Sys](c: CType): FastSystemAccessor[CType, Sys] =
    var fastSystemAccessor {.global.}: FastSystemAccessor[CType, Syst] = FastSystemAccessor[CType, Syst]()
    return fastSystemAccessor

proc setAccessor*[CType, Sys](accessor: FastSystemAccessor, procedure: proc (entity: Entity, b: Sys): CType): void =
    accessor.getComponent = procedure
        