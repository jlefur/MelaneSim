package melanesim.protocol;

import java.util.Calendar;

import com.vividsolutions.jts.geom.Coordinate;

import data.C_Parameters;
import data.constants.I_ConstantPNMC_particules;
import data.converters.C_ConvertGeographicCoordinates;
import melanesim.C_ContextCreator;
import presentation.display.C_Background;
import repast.simphony.context.Context;
import thing.C_Plankton;
import thing.dna.C_GenomeAnimalia;
import thing.ground.C_LandPlot;
import thing.ground.C_SoilCell;

/** Common voles' colonies within a dynamic agricultural landscape
 * @author J.Le Fur, A.Comte 03.2012 / J.Le Fur 07.2012, 07.2014 */

public class C_Protocol_PNMC_particules extends A_Protocol implements I_ConstantPNMC_particules {
	//
	// FIELDS
	//
	private C_ConvertGeographicCoordinates geographicCoordinateConverter = null;
	//
	// CONSTRUCTOR
	//
	/** Declare the inspectors, add them to the inspector list, declare them to the panelInitializer for indicators graphs<br>
	 * Author J.Le Fur 02.2013 */
	public C_Protocol_PNMC_particules(Context<Object> ctxt) {
		super(ctxt);
		// Position crop at the barycentre of cells
		for (C_LandPlot lp : this.landscape.getAffinityLandPlots()) {
			double xx = 0., yy = 0.;
			for (C_SoilCell cell : lp.getCells()) {
				xx += cell.getCoordinate_Ucs().x;
				yy += cell.getCoordinate_Ucs().y;
			}
			xx = xx / lp.getCells().size();
			yy = yy / lp.getCells().size();
			this.landscape.moveToLocation(lp, new Coordinate(xx, yy));
			lp.setCurrentSoilCell(this.landscape.getGrid()[(int) xx][(int) yy]);
			lp.bornCoord_Umeter = this.landscape.getThingCoord_Umeter(lp.getCurrentSoilCell());
		}
		// facilityMap = new C_Background(-.05, 26, 27); //chize 1
		facilityMap = new C_Background(-.1, 27 - .4, 32 - .4); // chize 2
	}
	//
	// METHODS
	//
	@Override
	/** Initialize the protocol with the raster origin */
	public void initProtocol() {
		this.geographicCoordinateConverter = new C_ConvertGeographicCoordinates(new Coordinate(
				I_ConstantPNMC_particules.rasterLongitudeWest_LatitudeSouth_Udegree.get(0),
				I_ConstantPNMC_particules.rasterLongitudeWest_LatitudeSouth_Udegree.get(1)));
		this.initPopulations();
		super.initProtocol();
		if (C_Parameters.DISPLAY_MAP)
			if (this.facilityMap != null) this.facilityMap.contextualize(this.context, this.landscape);
	}
	/** Randomly add burrows and randomly put RodentAgents in them */
	protected void initPopulations() {
		randomlyAddPlankton(C_Parameters.INIT_POP_SIZE);
		System.out.println("C_Protocol_PNMC_particules.init: Population of " + C_Parameters.INIT_POP_SIZE
				+ " plankton agent(s) created and positioned randomly in grid");
	}
	/** Fills the context with simple _wandering_ C_Rodent agents (as opposed to C_RodentFossorial's that dig burrows) <br>
	 * The sex ratio is randomly generated , rev. JLF 07.2014 currently unused */
	public void randomlyAddPlankton(int nbAgent) {
		java.awt.Dimension dim = this.landscape.getDimension_Ucell();
		int grid_width = (int) dim.getWidth();
		int grid_height = (int) dim.getHeight();
		for (int i = 0; i < nbAgent; i++) {
			// BELOW, THREE POSSIBLE PATTERNS OF INITIAL DISTRIBUTION :
			// 1) Random number to produce a sensitivity analysis
			// int randx = (int)(Math.random()*grid_width);
			// int randy = (int)(Math.random()*grid_height);
			// 2) Reproducible random distribution
			double randx = C_ContextCreator.randomGeneratorForInitialisation.nextDouble() * grid_width;
			double randy = C_ContextCreator.randomGeneratorForInitialisation.nextDouble() * grid_height;
			// 3) Put all plankton at the middle at init:
			// int randx = (int) (grid_width / 2);
			// int randy = (int) (grid_height / 2);
			C_Plankton agent = createPlankton();
			contextualizeNewThingInSpace(agent, randx, randy);
		}
	}
	public C_Plankton createPlankton() {
		return new C_Plankton(new C_GenomeAnimalia());
	}
	@Override
	public void initCalendar() {
		super.initCalendar();
		protocolCalendar.set(protocolCalendar.get(Calendar.YEAR), protocolCalendar.get(Calendar.MONTH), protocolCalendar
				.get(Calendar.DAY_OF_MONTH), 0, 0, 0);
	}
	/** Color the map in black to see the overall distribution of burrows<br>
	 * Author J.Le Fur 10.2014 TODO JLF 2014.10 should be in presentation package ? */
	protected void blackMap() {
		for (int i = 0; i < this.landscape.getDimension_Ucell().getWidth(); i++)
			for (int j = 0; j < this.landscape.getDimension_Ucell().getHeight(); j++) {
				if (this.landscape.getValueLayer().get(i, j) == 1) // houses
					this.landscape.getValueLayer().set(2, i, j);
				else
					if (this.landscape.getValueLayer().get(i, j) != 7) // hedges
						this.landscape.getValueLayer().set(BLACK_MAP_COLOR, i, j);
			}
	}
}
