# this script updates the metadata of a PineAPPL grid file
# specifically, it modifies the "theory_card" entry to update the comments
import pathlib
import json
import pineappl

path_to_fk_tables = pathlib.Path("/data/theorie/jthoeve/physics_projects/theories_slim/data/fktables")
theoryID=40016000
for i in range(12):
    print("Processing theoryID:", theoryID)
    path_to_fk_table = path_to_fk_tables / "{}".format(theoryID)
    for fk_table in path_to_fk_table.iterdir():

        if fk_table.suffix != ".lz4":
            continue
        
        grid = pineappl.grid.Grid.read(fk_table)
        metadata = grid.metadata
    
        theory_card = json.loads(metadata["theory_card"])
        
        alphas = theory_card["alphas"]
        mt = theory_card["mt"]
        new_comment = f"NNPDF4.0 NNLO QCD x NLO QED, grids as in 4001 but with fully NNLO TTBAR instead of K-factors, alphas={alphas}, mt={mt} GeV"
        theory_card["Comments"]  = new_comment.format(alphas=alphas, mt=mt)
        theory_card = json.dumps(theory_card)
        grid.set_metadata("theory_card", theory_card)
        grid.write_lz4(str(fk_table))
    
    theoryID+=1



